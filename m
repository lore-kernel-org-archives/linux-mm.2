Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BCDDC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 03:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6350B6B0005; Fri, 10 Jul 2026 23:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4B56B0088; Fri, 10 Jul 2026 23:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3C56B0092; Fri, 10 Jul 2026 23:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 261946B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:22:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 953F540623
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:22:40 +0000 (UTC)
X-FDA: 84975048480.23.790EC3C
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id CB8E0140008
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:22:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VoFdwkEw;
	spf=pass (imf26.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783740158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZoRTmK7mqG76n1GL0uhVSS5eZwslPyOiLYDvdkV1GQU=;
	b=B3CWB6gwQLibzgpev8Ac0jYe7Wi2PSYRlcjCUSKxi4RezRtJV/7B4+1IoPr+cb2n7kSuDx
	wnL4xWio0LqWP0D4fL4xUxbuU0uLknAlf8tUSls8N067rrU0vjhAgm2yY8V5WzhSMH4Zb7
	QBzsH+E97AVsHznNS88vkYXgjiJceus=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VoFdwkEw;
	spf=pass (imf26.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783740158;
	b=xlUCt9ji3wQ95qAh+PP+WzcXEjPOV6jUQMimuQKPW9OeZkD1XII+o3ILWrdhWeSJUR12RF
	rPPyeyHRfUpodjuxsD3tyQNBRMecE33IItZoCCHghr+TXtsTxs7y5Z45odH+bPaRdZaqJG
	CV6gHAvR7Nqs18J2OxvX0dIFo9JysqU=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-845c92bc464so1385463b3a.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783740158; x=1784344958; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZoRTmK7mqG76n1GL0uhVSS5eZwslPyOiLYDvdkV1GQU=;
        b=VoFdwkEwn0BhkVywlr3MN5nGFBJqOn7BygDj9hBgTlQYmon2s2SpWC11gjHOgvPqNP
         jFFB5y25mV2a3lPzsr83GB9rZiFKhszazEVVYx7kHIMWEiAiRAd2uaPLDMMW51/j1jcj
         5WYnTygWrGEwhqtCVmQhWrHRutOuHKJu/Brr6icjAJviBrO4jvS5lX9kgJkEJHqPLhDf
         p3hNpmkHHKHDreij1eowJXfjjTr+Bh7fUeg5NBC8PqFRK8SQLQjXhC4+wuJCcnwl9MkF
         gwGRaL8Kyha9ZyCRRLr3+utlME4qpkiCsGvaxcceNNeBQiqny53c4MeYDXR7BC8AzWeC
         JL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783740158; x=1784344958;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZoRTmK7mqG76n1GL0uhVSS5eZwslPyOiLYDvdkV1GQU=;
        b=Hjm3osEC3l43xMdL6WM30y/7nMoiGSrrAEg6MvTrGiHSWCESYdbtAi/fj/AErjFhZY
         ycx+tTef+HF5v2IFlKbK8Evr3GVtX9UjL+GAgiITdLUsRUZUG9vuJnlfzBUdKIg4sqvR
         DNxpQCkSsW3K9EXE0rEI5FT4sZs635jmdocfgZC/no7TpQVO79t+iY5T7hqhzDa6wcLO
         n51Lrgx/aOjdjys01m8iSzqW9vKINFTMPYg+rzy03ICl21w/v5c3h16vFle/c8d4zrKA
         jbFpdFWj6lE+q9QqFDkhFpssYMW728f6QemiXwNVwY2zDSgjiLQ5038SkkO6oIdPfQSk
         /OzA==
X-Forwarded-Encrypted: i=1; AHgh+Rp+NslLK0pe+eB3EU7Iyvur8DwEKbhW/Fd4xb97SOIodaRkri5MUKjcJz5x1zBo+g2zMIW8dChnPA==@kvack.org
X-Gm-Message-State: AOJu0Yy1RC5dBJz05xnzqIIGCxrk7mW/2eGTk5PwYDvrZgUy9U+QEApy
	pGxt1dtC/fK9Q4a3ulHt2x93yxdccwq95MIp/rIhzOOXbv0F1RpzQqws
X-Gm-Gg: AfdE7clcJJgEeK4ps/SEHoe9cJpYR8+usb5uHmj/b1J8RfA27wJQkfCf+hyUkPho2Ng
	FLdEgJNJmOSLJroZEGnjGlVOVgG430uk0/e2i9Vst2uM8nnbeXxnS4vbVg+LC6ddQvy8sgtJ68/
	bzOLplTwG+qmoWIWcm1OpOkVgUTHWX7Mmc2B9fc+6CmAswQnZ2/Q9UjOJC2XCJCEmzhUN9/t5pa
	vtd1U2Kngp1zaSP3ih5fa6dMLg5k5hzrga0sfo8dySNkxc/q8AjlnIncCB6lwg3bWHNagyBOWJZ
	PNWd4C5GNxrUFDaZGVvDEgQ4OzxThF9MmXb4QHrnyPeNZKRO6jQpt8Y8yMnbzixnFdbI5oNFVWK
	8QhDHKfd5pQPpB1Gpfg5f5ThoM42wc3l2JRSTXGft9lF3HjjUTAOEEiQasska2UE5JZxT9VTI3a
	O+/WWsHwqDbU1+H6ci+IPC5E8quD4RCNb84KjHdSz8oR3zKiNYwUTfGzM=
X-Received: by 2002:a05:6a00:2303:b0:848:2f74:1d68 with SMTP id d2e1a72fcca58-84889750a60mr1542258b3a.78.1783740157808;
        Fri, 10 Jul 2026 20:22:37 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84856e7c8edsm3652647b3a.36.2026.07.10.20.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 20:22:37 -0700 (PDT)
Date: Fri, 10 Jul 2026 20:22:33 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
	dakr@kernel.org, david@kernel.org, decui@microsoft.com,
	haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-ID: <alG2-RSitzPWClAX@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CB8E0140008
X-Stat-Signature: hn45a8wrrieegqs6ioz6eq5hb9bz6stc
X-HE-Tag: 1783740158-31150
X-HE-Meta: U2FsdGVkX1/8YQzlLYqzfGR3a+Ro8T1prVAl7EJZhn9SGCSWbO8Mr9QmZc/+mTahk39kbfoDmJ2XEbgIWTpy+PHY0lTFghYXh4H65e2Up/50+XjJolXEO6yLp5KmXNd/kTwwq7HyTlM+wDfb/Qro0TLWVYzEWOD4AJXwSey3I04arfA6yYzQaGX2StB75wtWp5wsZ4Zq33qVvpB/VRa791PnlkhQEmLZNedP6AyRDefCOvp/Yq0KRqQxoHjXdUvtRpbt0j4VaDD8IiEXUmEN+RUWWONmGbT0cTrpsVZk87tGyEvRS3EkGgjXr/FqE/ZbvEFcUqcJylrdkNDEs8qA5eWp8FAaa8hrH0AqHkodjWurpt1TsOTJSbqc/piW0gePCbGca/tYUb5q2X+aDGNRosGQlydiDFGIYZaotvOlMlp/V3v2KnK1vPIFbMZ4KeLU7iJSwpjkuyjSkcFwv7UvWbE2fgg3JGzkfH5XPer4boCbqMiR47jbMekLszDJzwLXiWBFWlcjD0btuN7lnB4UguyBI5wnCoNLv24ahMta++jaGOfVMcUaMgceBBnnnYNgX2TBFQM9vR4JSwbtn2PJXaC9xOfq/PfwaAkVxvtaqMobbzhb5uvBI2jtvCvb/LvZ1lFuY/er1MlHR2YZpNEV2YWSMUzIaPaRZMqIAXpFzlmoTdw/P6WONJ8vurhAKIzAJ4fc8Yl/b4Ifberd3zB9iICdlnrjPj/e/fxSVZ1rfG41XAbhs9tyPa01ccFSQsGUUTQqCxuiYyDdhtx8HTGLYMhD9LoMiIm4SXJDyKfYzPC+cphCIZEAjxbOvZ/WCakjR2PRwtAfkxwaAfRryVdvPIeOqVsnQksYmXuiQ35YjSYBxcJFatihBixbgRy9ncNE76C5eZqNbLVNRPtzDNkwUjO2SYTQr6KKdsuQI6VgXdJQb5Fdhb8nBnDUuyc1EAhoWb2UrhRcLo3kHVC0DM3
 ZuHjw/hf
 jtbTgKRqXZFbY6TefIX+qmlJu3iO126fgejyosKGvXKm0E/lTDeGNq850TU4vqNu2QiHIEuiQi1BxcHp2BMTD8Hm/9ntDbZ8vbHUwJATXTDV67qQTM7F2cysWWBsTuUekm4a1kWQTj1zN5G4F2vauBPywv5HaZD0EqT6Tt2AN1xQ6vdgfCjQ6IaKqIF5xgHTLwNPHsC9g3HTrrz4VWA2+ZszjNtk+QdDwEkn0dJj0n2NgxPRTkLISjRvD7Idqbb+4OAL0l1i4000TY5yj+4OCKoSp9+b3av3jroN3ribmEpZkoNYU/K4kgbvbtZHoEKM7GUvEmwK+JXhwHoFmZ8WHMwtLiUJhb4n5oprlCcnw5ZuYUMBeTOEHv57aWc2qSigiIlftyLEy5eZIZakeLpC8cnhDc5VFRYZVJVkEG3sdbPxlfp4VIEj1ducEouZLWOj5yF3nihSDH6K1RX4WKyY5gHD4rULYUfgMpgGfkRi3Lj/7MLvu/n44ftnDPHdDQDswM1N8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:11:51PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 14:26:20 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > This series extends the HMM framework to support userfaultfd-backed memory
> > by allowing the mmap read lock to be dropped during hmm_range_fault().
> 
> Thanks.  This seems fairly mature and mostly-reviewed so I'll give it a
> spin in mm.git's mm-new branch.
> 
> Unfortunately Sashiko wasn't able to apply this or v7.  I'm not sure
> what base you were using.  Hopefully there's a reason for a v9 so we
> can retry this.
> 

I rebased this series on top of mm-new right before sending it out.
Should I have used a different branch?

Thanks,
Stanislav

> I have a few niggles, nothing major...

