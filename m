Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014AE106FD6D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 03:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB8A6B0005; Thu, 12 Mar 2026 23:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3676B0088; Thu, 12 Mar 2026 23:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF956B0089; Thu, 12 Mar 2026 23:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19D1F6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:35:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC473C1F6C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:35:38 +0000 (UTC)
X-FDA: 84539625156.12.2BC822E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4DED0100002
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:35:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QOyegFzS;
	spf=pass (imf14.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773372936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8O0y76Sw4nNgrZ1YSQxVhOgzkbUj1DKbmac8/V7rFE=;
	b=W0VJnF/q3zLByPFh0JzCh/MigToYXC8T8xnJ/qOZ1/YSAJyBa/k0ptxkH5msMQE58RPmTt
	LqbDhSf2fhTyBq8/kKoBj1Y1pqaBVWGBLQF6adEmHC5hUC7Cjp1BxLEDNu2VhzLC736sP1
	BgIFLS/7GpM0btz0xqMoNbSPq9MAkYo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QOyegFzS;
	spf=pass (imf14.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773372936; a=rsa-sha256;
	cv=none;
	b=Qrh0TYYijGxK8LyLHiB9+TVX3OB29qGgUBeOu7L+GNe0cH1fcjt42xNBXy0+yfOBqjbejM
	vChBrnt2jBCwWPJmRwMsq++wWSPqoMMh+qkBAgPf0b3iU9eGXNQa4r6ru+KNj5OTaOsvrt
	pJ/fH3pGz941nT7ueHlhKIzjnpPsxew=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773372935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/8O0y76Sw4nNgrZ1YSQxVhOgzkbUj1DKbmac8/V7rFE=;
	b=QOyegFzSbGdIdohuOj9c9QGmdG8Znk9YMdegPYkbKYFjmaqHXe/kNxCoBqxZMo1XiA1S0h
	h/nyziLEUd/L9hGjn/G/iAS9/iIxs/TmrpIA1RUpTUTne2rDYwJLD2Y9VC4r/JtigvKyTJ
	c8xPcUYXDwIJucWcCCeL1o13huw47Cg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-SAuV-RnZMo2DjD0Qqnrt3Q-1; Thu, 12 Mar 2026 23:35:34 -0400
X-MC-Unique: SAuV-RnZMo2DjD0Qqnrt3Q-1
X-Mimecast-MFC-AGG-ID: SAuV-RnZMo2DjD0Qqnrt3Q_1773372933
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ae53ec06b0so111393385ad.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:35:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773372933; x=1773977733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/8O0y76Sw4nNgrZ1YSQxVhOgzkbUj1DKbmac8/V7rFE=;
        b=Gdq3ZPjuVJCdZpQkP/Cnp4YiEhXhojiaBs5UmWIIDDGw0sZIVRjrtY4ITKrSTC2lCt
         1Lr2xr5Kk5tI/fEHcRLGdnwCNaIAOv7ySnYrqY/RCqJpqO2ZCaDwj5abAUIQrsB2p+qU
         jq64ZWnkztSYNIpOg5PdTrL4vtr0VGBSmur03snwVb/bfAwdQubsc+Ygovt7nsr9IqBr
         xA3fxmxASbS5wxZhiMPmcbcfywXK9JFaSdheJrEVb8ysQhb4TEoseAo8kpOfq8kp0J7e
         3GnFSbquziNhxP+oY303qWAXB8ywqzeGN7Ez/Mva1S3breWxYII4sgBLAETFpN8FYlhR
         IV4A==
X-Forwarded-Encrypted: i=1; AJvYcCWC3stOTeKpEScDHi+qnIQB0Gt894D1Oe60eXOSVnpbVmbeY+s/SUAZyLwYmmDgpzUV95BOnYNcJA==@kvack.org
X-Gm-Message-State: AOJu0YwrOvGz2/WDNPf70QrPfnFoZXteRbEfyWFryeEnFZPpzNFvaONY
	Q+qCtYoX4z0t/JmSTt+dFgKr6/iJOtpgmNb5mdoBnjIYDdIAfAhN8U6ViJ0oigxiEHE7BuyScRo
	ITXuakmoKuHXioXOVDdeSBwutLkwlsTbyPhy7Gc6oTIletdgC1sJt
X-Gm-Gg: ATEYQzxax/pAg5eRhlrXaIbwDFNSvJRgNFlnIosGpy2WZGRrXwZgcqkiWAL9PDHfhY+
	Nka091Lex92PbDEYYdS09cvHBtXUsnzBjmaswaq7jaZ6lK8npo/JT/E0TQs0XyIGAfkyYR4EIDj
	GRz5iZ2EPEhdDBXoocn+UqsJsPekt4L1b67DLgyf35khZUireFU5GVCZBWLXTJeF0Vi8+yZ9AJi
	/766yDs6ooqmBxoozA/vV8mfgqEVuWG+d0yCi7oVJ1ZO+nE4+uT4R3x4oJtlSTUigxe1E/liSiP
	LGwik57ZJFsbvQFpngrWCzSFVXsEN6wyufFswgaXt1FK/y0pX6uU/f1aKdCj4m4xMLFMEXu+i0Z
	TvMZw32i1hbVQyibCjQ==
X-Received: by 2002:a17:902:e748:b0:2ae:c916:511 with SMTP id d9443c01a7336-2aeca9e0988mr18292925ad.24.1773372932789;
        Thu, 12 Mar 2026 20:35:32 -0700 (PDT)
X-Received: by 2002:a17:902:e748:b0:2ae:c916:511 with SMTP id d9443c01a7336-2aeca9e0988mr18292665ad.24.1773372932438;
        Thu, 12 Mar 2026 20:35:32 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ee5b1sm5475595ad.46.2026.03.12.20.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 20:35:30 -0700 (PDT)
Date: Fri, 13 Mar 2026 11:35:28 +0800
From: Li Wang <liwang@redhat.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, mkoutny@suse.com, yosryahmed@google.com,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v2 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
Message-ID: <abOGAHNnv9OZltdq@redhat.com>
References: <20260312040627.55257-1-liwang@redhat.com>
 <CAKEwX=MqyGQSMuVCSWmhKfHju5uHBe3ySQEgK9XuKwCvpL4x8w@mail.gmail.com>
 <CAO9r8zPmV8v0tiQvn2xFqX8F2oU23mfbVK67nxMO3QKt49kJeg@mail.gmail.com>
 <abNtUReAUHT6j9Rn@redhat.com>
 <CAO9r8zMh=tAV6UJcH3hhZWrZJO_emVe4raiq4wiBEgC-GAD2=Q@mail.gmail.com>
 <abODRsaeEul9Aj2X@redhat.com>
MIME-Version: 1.0
In-Reply-To: <abODRsaeEul9Aj2X@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lmqZ-HSyL35iU_ueMVMqN-vyRjFjnLW_Q_Z5Aua4EqI_1773372933
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DED0100002
X-Rspamd-Server: rspam08
X-Stat-Signature: a6n8njgemruou4katwtt6mdxnwtet615
X-HE-Tag: 1773372936-450137
X-HE-Meta: U2FsdGVkX1+jfpYiZRaVTIyjFEBEibk/tHj9KTIX6Zg5CTRq2Kkl9olltNAeUWYJXo7Av6+fLFIOQNqPNwKQEcnsObrN5sZheKsoUzgS0L5e/N/3C9r9S9nfAdMo8NLQaT6OVNpI2hUQB/3Pg5QA3UUZGmqAxkcmOZ77UGUQo2jZj8hG6egac1ePrt15rEcnh1OXmMoCMenAi5V766aHR9DbdTe4mGwEANg5jsyaQ9gpNysd53qhXHwxa8QHECe6TudgxUPhn2Bq/6a6EVUr+IPbAyvpMDjGY61ZIqrAVMywQ4uE4En1oMIpvcOltDGSHSrc5yCYPW7X1HjSMmvlnOoLY0AvuY0W4B0nBQ88vflQW95zGYPuMrb368DJz/uQ9bVLs3O4oudjLJFZG3v8H1VEmaz1EENX32wbVoY7Vw/6kiyQ6l3+x3Qgoiji9a/SxbS5pQxlraSm4zPe+QPJWvdMfUhZzyfM6STVgGrDYY2O9uCZZyWKji0mI3neVO6o2QSJ48rIdCzjw0Ncv71ILOgqVXeosdcsHwggK9y8WufCU4elYs7WyITvPcnmx1w+Ovfl/AeC3cGws2HyPmcfvQqzPg1Vnje7utSpJn0ZUe5r2ga4ROnOGur7NwDbzpM2X60Cqny+qEQa8o2C9UU3abDoP6/CL2sSVE221wj8o+Mhu8/j9rjH9J3NrztjWvPmFZ40ze0icP9fWkcuwD7Rul/qKDiDEA0uPUBoEMtuTFFVj5GRgTV3DpjfnAoeYzMk9ZETdbIW6MnVjuk1YJJvUbhlyiM2BywBwbKBEEeyPh80mwIOQE/oXGOOuKRqZILTMxBQf8J4fK39K9af7BG207qgZ3lCRe97MUSRmh5CsUgMBYy8etRfmZtnL/BBIMDLp/oJoMTlRbT1SLywZsW3weQow+VIpse1DpBmU9DjOHgdf5Yae6ufC8/8ut+TwszE26xz6K4CxBvRf6tX9yE
 gqvduTTh
 9q7cQa73rtE73k+LcovncSzTmeU9mkDfVLGHnjQv35u/qvdxMOl1hNf1Y1QLPJ9K9jGK74MbQZ5tUjtKTkbZdD5JZh7kHMN/Ym4QLLseiL6KZ/52LfV43C6yd380s6Gp3NchRajCyfuWCnw3wqaS4Kh5gMdeko+2xcN+DquBbxTf0ICi43KUCyCMVGGtuSrkjipz79bB2Py+glwfeuGEiT0Hud8vUKKtPqm4ErioKym8dqwOvInDY0s8ZPiNa0SMR+RLUHFPYwhMA5eDXRbkiS8mjfDlnf7VB0uoOetkU8nIpVXhL2H98u2px+MfpcUdcC9yrW24hd4XhbIvqferIg/DR63HJckQ5nLsPrU2p0MOl7A/1afYSapAObOqcI+4JhOAcLVNBAUVmVCGKno5ZgW1UCdCbSmHgtusuUcEpy+kP6Bl+UOeesHgo9z2yPLnY1D2tYkxPhmESJbg+1uM9T4f0zwDCAgOhwvJu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 11:23:50AM +0800, Li Wang wrote:
> On Thu, Mar 12, 2026 at 07:58:28PM -0700, Yosry Ahmed wrote:
> > > Yes, this looks more tidy than open it. I'll go this helper in v3.
> > >
> > > >
> > > > static void check_zswap_enabled(void)
> > > > {
> > > >        char value;
> > >
> > > read_text() requires string but not char.
> > 
> > I was just illustrating. This should be passed in as &value. That should work?
> 
> Yes, pass it as &value works well.

And use sizeof(&value) just get the pointer's size but not
the buffer size, so I would recommend: char value[2].

-- 
Regards,
Li Wang


