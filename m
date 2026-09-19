Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E5DEC982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 09:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EAA36B0088; Sat, 19 Sep 2026 05:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075366B008A; Sat, 19 Sep 2026 05:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FA66B008C; Sat, 19 Sep 2026 05:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEF936B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 05:39:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EC7A160201
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 09:39:54 +0000 (UTC)
X-FDA: 85230015108.05.555D17D
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf25.hostedemail.com (Postfix) with ESMTP id 73509A000A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 09:39:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jjqtGyX6;
	spf=pass (imf25.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789810792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7D6znmpASqvbzZksdBAJ2aUTbJ7HvmNoE6FBY58urg=;
	b=AhA/ViLDh+oBd5jycFY0uDK5h6KMWykGBoFuxU5mGIoTPOMLkeXqCUE0NTPM8w0yHmGGdz
	z0DrKF1qblzmd/WrEpp3PQFI11VIC/rIuaNgqCdLZisPRl8hBNWcMJgyXUmDFscc5MQ/Li
	khcqV/ZcDklv/TGUtEDBBwlIGACQA7k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789810792;
	b=z2RfqHUknWElSIpUmGxg0CTOPW+vtdGgLXlYAMe2ltfWFvi8DveEB6VOUGv90o4D2OVmfz
	ckKT1cTeSzJzoQNdLTXyh8KwIjhBac3PWjmUnSxUdCbdCnRh3nt1W8vTZyjJx9HDpwo07B
	XM+8RfYZ7FnbupxghM/3dNNnO0spQ9g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jjqtGyX6;
	spf=pass (imf25.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d822dso10716075e9.2
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 02:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789810791; x=1790415591; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G7D6znmpASqvbzZksdBAJ2aUTbJ7HvmNoE6FBY58urg=;
        b=jjqtGyX63cta8l1Ff85Kpl8N+C6uJu6EWBXTC0d5j2fZMxjdqcopWG5jY3U31ur1t6
         zplmSSC0M/0dzOTlWYSvHmQLrYg44zjAVoJYdBeVTi2bZgnIIqKxx3dD1t3ETcEgaJ13
         qYmHJXZJDPgZamJKednOLdu4orQPQN2ImAhGmQU51eCycssE3XF+Bqv3Z8HVduFiBy99
         rady6CM3MOIdEbLhURg95VrcXBoua8l7swQYPeHqN3LqnTLt/hUtfibI3Lx2R8/CrLJ6
         YLadwdQ/Mh63kR4ht5ytBgNTqkYCLcdrtx5yy51PJ1dTlZDun5fOlRKPEh/Gyr11s8r7
         8AEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789810791; x=1790415591;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G7D6znmpASqvbzZksdBAJ2aUTbJ7HvmNoE6FBY58urg=;
        b=ElLX2TWNauZUGcgltNqMaI6I4mr5Qb+n7paOP1IZrjWh9jDFmSrIsu93QmEQ+qH7v0
         Cvj/ltFwVzhQmFW5Jdy+ku/zIaejgXvTmDa6MqslT8c2eXBKnLnMFToWCv2gCQuf7SvO
         12w7XLYH09h49J7C3TwTF5tvGWapiIbV/ySznjw8W6YfoyXCJ3UYrgMLVPuzhn1Q5ugZ
         dVnhUMcsyFpyv4nH1bN0gjo/3xgP7D0AS0dTXY5LLTuvrM1PV1ZbUxfXTSzEQPLJHItD
         WpaHRTj0Kk/vB2KIhLcR5jG9y1I9i6syaOZKy7znTr7egFsugwueD7KoUCLvbGZ5Bb8p
         fJcw==
X-Forwarded-Encrypted: i=1; AKwUvByDz3A9OKLj2FhMxOzcGNL94H2eHDhrKQzMSGTx3teMhdAr6ErPDXcll9dEJEXbhJbpmlyEVILrBw==@kvack.org
X-Gm-Message-State: AFuF++npt3CjziuNZ+hacTw0kHPKId83IxSpaHRDxRjvr1wTrJq/gTxT
	kvEB7b6uAxmDSNG7OapeCMQogX+OHOa10rM7IlluaWiWGhZArdCkj8uQ
X-Gm-Gg: AYBFou2zi/UOPBwVarsYETocX7y43uqNz6TWshQOvy46/OnEIwGw3YJsz96OQ4byxfu
	Yc5haZjCh19Hc1MjGsk5jQ02PloXicXWptLILX46717gKnKkCEkM/2x8KYnBABSySYGmu+Bjoqg
	6Xo+Z3xwC0qQNAv7Yh7N+VFk5ah/ET6Z/CA+cBEhy0HFXtXZ9I4CCTYskYuQdJVDLeYAXBNQm75
	Agqs+aBgW8Z15a9Ugj4Y/aNdpxHRhetgndlBb24G00Z7VF86Ywm71wr/78sdo08Aos5yKWStmA1
	BGPFc4pHY5u4lnArHy2/WbudbSHX/3sGsSpThkQro2m4rQJ1n6A+4570fest0JS81T8Gwrtebeq
	++SqCiLH8XxdFpxDvX0gCcD9Z7ResQHow3YxGj9SEufEpAB3m5gUpsl2PMZs7F+/145GlkBd2et
	UX33sm5OSQbn6nBB2eMePyo04Xkfl6ZdeyLsYJvwC/rUCCkGNmXboapfX1w1uq3REtfQZIO9ERl
	7hbdGlWVGYs8OpgFcBnD4mBCMO8szA0b/1NsJWVZW1qTMwCPe9wBVP/ZcIfmf8KuSeGyvxoDIA2
	QMDrB2vmJGkHZj06WqO9Mz0K6RakbNS8CYE+ICzXCcIEDHM35Bv/xI0bL94gpoqA/hbSZuclWYS
	l/AwejScJ
X-Received: by 2002:a05:600d:848f:10b0:49d:827:e5b6 with SMTP id 5b1f17b1804b1-49fc5735351mr48923145e9.20.1789810790822;
        Sat, 19 Sep 2026 02:39:50 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a017-2b01-05fe-203b-7cd2-a640.310.pool.telefonica.de. [2a02:3100:a017:2b01:5fe:203b:7cd2:a640])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc6ca43edsm124495965e9.0.2026.09.19.02.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 02:39:50 -0700 (PDT)
Date: Sat, 19 Sep 2026 11:39:47 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v3 3/5] slab: handle ERR_PTR values in kfree and hardened
 usercopy
Message-ID: <aq5YL3P6tuFy4eTU@gmail.com>
References: <20260903203720.63689-1-kmehltretter@gmail.com>
 <20260903203720.63689-4-kmehltretter@gmail.com>
 <497a85d3-e062-4930-bcb8-c86a8205e7b2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497a85d3-e062-4930-bcb8-c86a8205e7b2@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8qg1eq9wmqbfmte3af5ue338stwd4t8r
X-Rspamd-Queue-Id: 73509A000A
X-HE-Tag: 1789810792-864703
X-HE-Meta: U2FsdGVkX19V8HxlKKZhSgO0U1F9m3lNhTjXhCKKigr2BsrNc2M179B0Wq9pQthZqeYFR0z/EEbBLANdCdwcWKiVrqypFuiH6VKP8LSIEOd2bUniNM5ksi7eTfIsG8RlWm+IjFaptjz632x5Lcr/PjKYW3t4SwraWI6wYVuCcK4QQe4KNEjcg7wFv1s5e14tvYW9fDM2pjq8yWylh2cr8ooQ6zYRHhb1Y+NwkTCKC72VC0/EbGQBlawRR/Tbx784NT0LLqqded39kSd8pi/F8d/y1KPjrYvclO5RxsOCPXGdeYPP9/4VeaT6lgSESssiUiOsrSV8uuN4xHjgsvKjA3lGZ0w3exOsXu8e+mw06Vs2l7kNtCOLfMEblJogxxnHQgWze9vVfY5dGHbU+8FfBdk92dplU0sAlhs0j/XfVK93/xOQbe6nCoQFwvayl13LCrSVP1FSKon7k+eMJydqHvT3tw19Hm8VehNyJsMFPEGSfsu5ERp5VED8W43VQlUrcxpZEp+Sk1z9Wmqwl8bWD1YnLCXeLbEVteD5ohMGU3enTG1oWfl6ukF1lXz0ZTIAW4/k5hefwoz4qpU5TUn1tBrqD+ZU21racEiNwFDXuWS0m5AHR/URILra3Vc/GGqoV50pQS8oxLNvBmk8ijDbfghjvQLw9GL+O2NA+RVGRXzN0ZRoSZicGrkTn+VCjpBGpjZ5x3at0M3gj26yGWMZgoNyNoA1rDVBRc0ZdeOF6/8pzS6pbiY51geJRRsczd2Lq0MCWKFPu10y/uOCAccYCjzNG/4wNhrrMZkGpXwHBOob5ftSjxKDWTAIvphZ1rdIS+EP6SznMKqeJIAjIolmILR1/JKDTZitxfal9CmBYmIqfMbmxNn0YgZhE17OUqby5Ug+gkJo7ItATTMQRGgzarjthW1r/RcVbCdQ5ENL4sZAunAPMZnEZuob/5AdqWBKPrlxylou5huNV8mzWKl
 BkmKyX8w
 dsZtfxMbpOnRxqj5SDKxRpFQMuRzhFUUtxB1ezGtAq8Yo7763seRTfh+n7tr6NST9p4dGW4WOLVLeOLJLidnDLS+a8Xtt2v0FdrUYfQSV5fPQHTf0vkBz37eCve8JSIXxFI1ahPb90HX/dV1RUQCNlj83QIJYzyS73Fj1FPDI+JbLka6lejQESZx5v777UdK4zVCqnY4HKqq1I2Lee4Iy+1ElvT/PYErryB8otrFiyqxS0+lLYTxlw+VLghlSCmR3OcPSrFVoZMcueC/nrD2h9/jVGVm1fffl+9fVGZ0kdwdS6W0oW59FLKNVdR26H5/G7+TP5lVgK15x40nedTbEC6FN2mM6e37fJz0ULpfBiBdpgaQwgMdQIzGVtP6tJOT3Jf0vJI9bICMaXF/Sr6ygAruT5TfhkXdSqLK1g5T1pu0d8ZQAjLOKLqb8W6K+U1tgTWAVSloXyMGWziCKZaLJw00xV4guUhTXHbc3LKXFkXGsafzXvgumbkBBF5nTtL79X6cPHVPlaUmS+5+XVR4gFnCDKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +	if (WARN_ON(IS_ERR(object)))
> 
> Wonder if WARN_ON_ONCE() would be better.
> Also wonder about the benefits for hardening (as opposed to debugging).
> Without this check it would fault. Now it warns, but hardened setups often
> use panic_on_warn anyway, so the result is the same?
> 

Yes, I'll switch to WARN_ON_ONCE().

You're right about panic_on_warn. The benefit is a clearer diagnostic
and, when warnings aren't fatal, returning before virt_to_page().

I'll split out the ERR_PTR patches as Harry suggested and recheck the
KUnit warning-count test with WARN_ON_ONCE().

Thanks,
Karl

