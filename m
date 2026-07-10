Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE422C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB546B008C; Fri, 10 Jul 2026 14:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7BAD6B0092; Fri, 10 Jul 2026 14:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45CC6B0093; Fri, 10 Jul 2026 14:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A00D6B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:03:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E796BA04E3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:03:16 +0000 (UTC)
X-FDA: 84973638792.24.53F2D68
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1F0C61C0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:03:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=IIvYT3IJ;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.170 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783706595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pchhQjIZYIsHA+IyTP+kMOXOCiYK49mahPv3eolm7bw=;
	b=fXDfMMChxZK0akVaJ71CdMevWcMNLK9T1e/tz9pItWMNleYJBSvtS6IYFWnF36UZwK4AFo
	Y1yiNTXRGHMLw+xbNiXW2nPWoutBD4bn23B9NI5VpmqNIdPXTw4isJhrwsLv2md5tnHfox
	HS4Jh+RU5ZsRYmNs2c+kLlNLLfMUn4g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783706595;
	b=m1L3D+/774eIlLAmiYUYfjYbvlTLfsf0TI7qy9b7LNyS/D3+bAEhFLrrQN1M+CwyIM4c5q
	d+u/k6KSFFheOALfoIfPx95Qund9Fwq9VDLXcOxWBTdSsP/FjGCKKA94K3IgeP3xwfnZ7r
	9WUJKBZMl498wSjs+f6afrVkgU7h8tU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=IIvYT3IJ;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.170 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c2a449c57so7106911cf.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783706594; x=1784311394; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pchhQjIZYIsHA+IyTP+kMOXOCiYK49mahPv3eolm7bw=;
        b=IIvYT3IJ9VfnYKnM3z/Ole0qvK88aR7hdUQ7txUQMZuexzKJfDxJWdtp00AdUll4X3
         KwNCSGBbFgd7zGSriqNr+S/gqOKK7Zfx5ljNzJSB5Ht7NCuCiGfLHdthB1o6R/BQZhXy
         0HphMI8Ud7CQpkR+aH7/Uk3Ytb6IfrPtGaAzuXddGDiyORzwlNs37F9OtQQzv3RhjfIJ
         iHuu+CKHDll2M5nSc+2TCEjHc6llseQN7lkhnXhwrGj9FVFFqsDpRlvRRFXXg/l3e3A6
         +7F/qmRS4FzX+XxAaybTGXnnrzrItdAswe4meUnf7HxX1y8hUknh88Y8lHH0lYrNaFOk
         uGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783706594; x=1784311394;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pchhQjIZYIsHA+IyTP+kMOXOCiYK49mahPv3eolm7bw=;
        b=MMS0Qz9Spy1FeXivB5XmFsQNB3zTHLBIqUEg+a707Ka1G+fP01jsV7MYc/lSkzSaMN
         DPNE6ltyxRnq1Hb6VOFhb1JmIRB2WUws86eJupcdzcJpgs5CGfnz2iz4le1ddFULKkhv
         kRKQ4dnIN7TFYoxyTg/KEQxa+KJYEIGsvNTgpJU4zgPOFxNYCYfDIwCBlJdl4zzeF/Sn
         Yuf4tkC7r/vhBYLiHNmRD/ozwNhseGAqisJgI2ov2eQZzTOCDkc2W+2DbeZIJXYVDdre
         /Qnt6Qaldi5TMnhbfbD/4r6Thyo0KwXerrO+PEiRr/o36wlBteXiedngdeBwLiwLoDZZ
         kd5Q==
X-Forwarded-Encrypted: i=1; AHgh+RrQBxesT6VVKyiOHqYkdSYxdzN/f32S2rEgDdo2VeY49oNn1VsVpyqKB0HR6HDJiSqr1Df2unLn3w==@kvack.org
X-Gm-Message-State: AOJu0YyNp6lFiMS4AeeDkLISbkLYXTEv8c12CBcdhEKNG6oyaUuKymNX
	LrG1YEfLNusLxUcwIkXYdtoeib6Ayhc/HJxBad4Ktqq2X/3lRIVq7gJWeJr1q5lKE9g=
X-Gm-Gg: AfdE7ckNT+45cX6g3XgBMlxFINXkFOgOAfZLjqdCeZM6Yu0peymc83N1OZU9P56b4TI
	nUXI0OC9XBZw/79bFFOynATlS/JqQ9na9VFC246kQ0rh6DNsuts3mHTaYM+rrix1uYsLbqKtUcL
	l1HEqPeCT5NHDtVFsRNmAy3DgPMb7sHnAngIV92Yo2/XCflnliJoeMtO6au6id7FxMp2LY9mG22
	i6PXHRH7gwxWQQailPwUny2HpIQig7lXrrwJ7RtbYT4aKBIWqOQYkkR9rYDjXcE07vmpD4V/IHX
	90GTh5HBbFJZtCgxe1B/TjNRmX4aUTUGm+5yB3rsIurWxDLp6KFpg9iueTw41TikJm/FgPSrdUc
	5KYTNrOMaFQzmHJdLTq1sSYJJukj1rOPQ45X096KgABmR0BW44iu8iqUI7ZJ0
X-Received: by 2002:ac8:7e8c:0:b0:51c:7b13:62fa with SMTP id d75a77b69052e-51c8b438c0dmr129494461cf.80.1783706594020;
        Fri, 10 Jul 2026 11:03:14 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1fd2bsm47060696d6.27.2026.07.10.11.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 11:03:13 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiFZA-00000007fhc-13JV;
	Fri, 10 Jul 2026 15:03:12 -0300
Date: Fri, 10 Jul 2026 15:03:12 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, kees@kernel.org,
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
Subject: Re: [PATCH v7 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout()
 for mmap lock-drop support
Message-ID: <20260710180312.GD1803712@ziepe.ca>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345362182.660027.12809852179204464964.stgit@skinsburskii>
 <20260710162749.GP118978@ziepe.ca>
 <20260710164743.GX118978@ziepe.ca>
 <alElv0EKjLQXMNK8@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alElv0EKjLQXMNK8@skinsburskii>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1F0C61C0009
X-Stat-Signature: 6re48ztpwfwsteydbsodm4wgtcctxq4c
X-HE-Tag: 1783706594-491998
X-HE-Meta: U2FsdGVkX1+bdDvYxxFkz2tB8c2gFsREq57WhRGd/vqyIwFNWXhoTXUGqixRoJlg8wg0UnnYTU1nGDwMkrxpVLkgpdvSlPG9CSLORfNAE8tNPvHlp1qLxchp7lGOWgwojCaMsjMFve42VdJwu3//8imAdblY4IjhsUTe6KsormoGFFUQO8MbXWJbF6aE7vfJEnrOdgQ4IKrNbkjBKEl5+jX/ZpkI9mtP+b4uTX592B7ucVtkgpXyliNSLWjCSdlItbvHdYclil0z91bp2BanC6FFr6z1PKnDp3XMmLsKFqsdwlB14ya4zpHnyQ4MlBk3j1U79ktjv/AsRHkdRhDKaJKI9Lh2u7Hpo+SXEbUZ41wRyfvE3qpkA99NWMIdJpN3asrrmoDGiiBZgU0nJ74WGllLrBCoLxyNeroeORf4ZgWKrrzqBwu6GLvzr5hP9n5HBC2Nqd4Pk0/sUfgY6abdJmYy//avK+LHtCm/JdVuT6QxG+7HOsYRZrZ4xdtEyP3mcCuaPe7PXM67Skmnpr4jAM3Bbh9byauB+jDJwbi3I1pE07jLgX6ACl3Mf1Js/RVyBFZevWPx2P1MyozAZ4AoOMvT2Q61+9Jv5YVIo2dg6EyNb8m0h+zaBeVCF+znAFvVqS1PO6viwq/rM4g8gnd4YJx8ovcw5KAaZy6bDleeTPO1Z/jG+mQJ51/Ajokx6hbhvEMaVn975YHQDZkhIPkAPlrWEcelRSVYS1EfTZH4n9vpi4v4a4aynBHRAJ1w4VfhvWespbMWPYq7W14zSnMjr/8Q+rO0wuvv5/J3OA7DVx5c3oApIZ2k5J9Pi+2VuV+cAQxve78fA/8g3KJhmbPg+FefgK3l69sLHKf4p8Gl4xgsjQ3O87tTg6JaUvpg+OG+jL+i7ISPrHvP3aJUdbygbC6qdDjjRBxrImX1S/w7mWy58BxsnMTPkh62gCNR+zhv7+002HMSx9TTaZ75wUe
 +pC1Rc10
 6OLXnLyoxgTYuGC0XJRFXtoR+9d/K6vnPfCTLKW3v/1MPpF++1d/D0jUJxBra6VeVMnwBVHoLahTS1ukP7C51P5/Dva2QtuWXoT1T70qTL7hcNvfpj55O56v9MleC9SmoSoJv5boMwUDbDn+fxP4kWjeZfdBYlUjvud+ooRJjfzazQpOs7Z6FRrn5YSkHd4CFWgs4Q562yGVtybBXgkbsglaOAyi1ltT+QTtry5KsHsRZ9v/XdaAgOKX6p8z+wMa4diOQKaTpcbtzIiZSB+Ij+n0mToDv71XF8o7ByLKPw7Xgp0PpqTX/OHcNRn43PNdnyEh/gM72HSp2B8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 10:02:55AM -0700, Stanislav Kinsburskii wrote:
> The main customer for this new feature I have in mind is the MSHV driver
> which backs VMs memory with HMM, requires userfaultfd support for
> post-copy live migration and fast restore and it doesn't timeout.
> 
> I agree, that this current timeout value used by the other callers might
> not be enough to repopulate the mappings with userfaultfd, but there
> drivers would get -EFAULT for uderfaultfd-backed mappings without this
> change anyway, so getting -EBUSY with the change instead doesn't look
> like a significant change to the behaviour from my POV.

It sounds like it won't be reliable either then.

> > So, maybe the deadline should be resetting after every handled fault?
> > ie the timeout really is only about the mmu notifier and we don't
> > count the time spent handling faults or walking?
>
> The timeout was inherited from existing HMM users rather than introduced
> as a new HMM policy. Some GPU drivers use HMM_RANGE_DEFAULT_TIMEOUT as a
> budget for the whole range population operation, including HMM retries
> and subsequent driver mapping work.

Yes, because we always had a timeout around the notifier because that
scheme can sort of live lock. The timeout was to protect that only, ie
limit the number of notifier retries.

Expanding the timeout to be outside what is bounded by the notifier
retry is not right, and heavy stuff like mapping should be done after
the hmm side succeeds and the notifiers concluded so they can rely on
normal locking instead.

This is why I'm suggesting to reset the deadline as hmm makes forward
progress, we really only want to bound the notifier retry loop not
anything else.

Jason

