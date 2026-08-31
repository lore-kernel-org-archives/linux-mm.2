Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA29C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65466B0088; Mon, 31 Aug 2026 05:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3CC96B0096; Mon, 31 Aug 2026 05:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B306B0099; Mon, 31 Aug 2026 05:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 970E76B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:26:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 286E4A3F76
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:26:13 +0000 (UTC)
X-FDA: 85161033426.01.9870BFB
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 699C640006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:26:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F7dxPbDW;
	spf=pass (imf07.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788168371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttK06hi5jQ+IygEkiO3ryeZPLThCrdKZVEsLhx+wvL8=;
	b=Erz+NDKy7nwKFL65HIRbpD9c26j0uGVpxxtB5J+zCX5uRIeDlkRIhiw2B2Y8OhXikIjWKF
	vKey7HYULSuDahV7pQNK565oE+/ZU9qFmDYEptdlYnSFqxjZUF40fKSpsy4rKlDZg6I3it
	6mo2dTXbxutypVreYg3kCH9haxAqG3Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788168371;
	b=CoKtgTdqJwcG1+SesmJvNvgt3Jk/qVXPmhfU1VYKnzc7wuWd38nkuD70ONl/Cb4q0IMcyj
	pdfVdWBEws1J5XDQe0hA9ku84WGEXBTr8N0/jc4XYGzRPXDZPjwcbW/9R9HwNjxQr89/AN
	C7gEl3nT44jzZ9mlrRvJstBV8IzauVM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F7dxPbDW;
	spf=pass (imf07.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-499ae1c6471so23175195e9.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788168370; x=1788773170; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ttK06hi5jQ+IygEkiO3ryeZPLThCrdKZVEsLhx+wvL8=;
        b=F7dxPbDWL1d1ZmuCUrND4/aF+Q1fQgg1SfHzqY+SmOX5S/A8TscYasR3yNgeVB3wx+
         669GtXS9ExseIwtzW36KArPDp5IuUDjvdo9elkAPQNQ2R6JnaDW0zKrxK9EHSP0Nn9RE
         vZw3wlmwRb3m8e2fT5iqAKTDTvjxVXZPElFW+kR8huKOitO9Ga3kpcGwWgvttSooks+C
         +d5eMXHjesTdbRXSURsj2KTrtA355BlKxO3cASibcLZRyxDmJCJxjDkZKsj/fw0xEZ/U
         2fcv1aTlYJRMQ1NXswyB14Jb1lV+jCuVOD+h10Ju/fu7LLbIF6o0oRV24K+ZwSyerEj5
         Cavw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788168370; x=1788773170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ttK06hi5jQ+IygEkiO3ryeZPLThCrdKZVEsLhx+wvL8=;
        b=eTPkABZnzov/B6RAmtp30ZbTDn2rj0r6cLRSq+f/JuTHpFJ2jg0bt+6M0RzM5vtX53
         s6JRiDkNJgJtECWMoJONplMwCjb57pWHcwGXff6GL33XeP7EezoTuqAeWDHo4oOSF9LI
         NOdH666SV+Ob3fL1HUkQ7Qa6YBR4cNpYeEgQYKW0IZGiyngdm1mes9BWpj1LkGsbYPDr
         ph6ZBDewCjWNynPyF9Jd7kp2UF9JRgPXNRje/IftxgUke1hX8jQIzWqhf196bT4BiW3M
         CHwj67lMpFSrsvEWtPiwr2ILJS8Brh0HQl9ME0+Smro/Om6lggCA4z/qfxXP0wfLo5An
         bJ9Q==
X-Forwarded-Encrypted: i=1; AHgh+Rox/SDKp8yvAK1x8urtdjaOCMs+H/TMtnqzBruDsGdGK6VtsewMtPXT5CKwDwEIFQQRu+oZWGhh/A==@kvack.org
X-Gm-Message-State: AFuF++l56elkexJAV2MpZml315HMaHPBa9stNs4vQq27tI7/3p08gbUc
	rYVsFB0v0Bk0ZudMUsYTZvuLGQt/rWVImpXmwPvC4AGkP1gPhibAS1jl
X-Gm-Gg: AR+sD11XDhsyi4h9qlZwHiwRss4EIEh2c3ML+YDNE0UfE3jzc0NswEIGGsMdmup9PDX
	qKgmUXS5l9jZ3VMbXPV0GPBik1HlKANjZdEzy2IElyF2JIAGii9A39wHgk9RP5Kmks23sixzefc
	4EtaqcoPvrTHT3zdE3CUc66hmHrIpLPCMjH9Ijb5XNyeJZt/ueMtxvom8ZDYQNZwzAZNfNItYm1
	7c7Bn4/HLOhvSaLBFeDEIdHCLmEruWNiGs5gL+sPZvOwfriz6jnBxyQ819fDB/tOnZRWJ4KubSn
	03Na8GQPb3eAsvyg87YiHH1tw0WbwiySd5kJjNavFYTPtyRERO0DO4Yaft3JQKFWRnqj5afBEx6
	lrSjB36icGtHkRCF5fn7ioYYmar+HJDWdkbXVRvyZgoi6mk2ceHMf6Ltd3w5jcNOOmTozvKLWP+
	ESCEZoYvmiXfoYnyq/XRhUtMIMgULggyiBatI8i0gfgCV5Jjz+bOREEl2w7N/vnh4TlkJOxDYUu
	w==
X-Received: by 2002:a05:600c:8b35:b0:499:cd34:f7c with SMTP id 5b1f17b1804b1-49cd9421bfcmr29162715e9.5.1788168370027;
        Mon, 31 Aug 2026 02:26:10 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49c5a903eebsm171374105e9.4.2026.08.31.02.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:26:09 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: andrii.nakryiko@gmail.com
Cc: akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	david@kernel.org,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next 2/3] bpf: Add user memory access kfuncs for linux_binprm
Date: Mon, 31 Aug 2026 12:25:47 +0300
Message-ID: <20260831092548.42348-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAEf4Bzb9szFTDo5uUxLgUVD3qA1XF-5A7GZGxJjX6d1MYLhbFQ@mail.gmail.com>
References: <CAEf4Bzb9szFTDo5uUxLgUVD3qA1XF-5A7GZGxJjX6d1MYLhbFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rtco6y3t3jofjc1esudm5bx1o9qegxpe
X-Rspamd-Queue-Id: 699C640006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788168371-957210
X-HE-Meta: U2FsdGVkX1/Y1V6kgB21GOFVAQzvaaSz5IZd4wWAafRGZg1dtJhdgzWYVuYytO8eSPTvzxUXxBo+aDSk+rtw0EtEkXwm265H5Cg8Xk0Ok3xW9GXlo0RcoY8PvK0bmyk2ikp1vrtn5rvLw8+YWjXxgrJBkP5XqIiWfH6uMOvsgihZc/sl+nbbJfCmRz+2kZBVSdVwGrKmHbhYlQul6Cfvvt4+7UCFwcvP7yNJjTvL6a4+T3ov5DqfB4Wv30wEZszzulmffQ/mjx4l6ZSPAe5lsYP70nyrCPmKAIc0W6WD24WOMx6R0qrJggxnhupwCui7hO+SDryR75r/z9NeqkkQ9U0RgxG2mAxWgvMexquSSO5mt5NjIa3/8XXxNO/ZxtwOKoJ4XOsW0QriH+vvTZyXVj46VsZuTcnrK8ZwXUlJ48yY8XdApBCnHF4GFDUBRvvOOWsM825NrdYtp5m97LI6H3aUxZkduh1410LGxuUUfgv2YL0+9HsUj624ZgSjpfQz3/6Jft1Wb8j5NYNR4SM5SWcKwD6K9KpINtrFspnlDVRYasVvSaJGAlQ3PK0wcgi/W30d97+BfnzYmIj2+gs1QJI/W402/qcg1WtXqOi+JYMyalsGSd+YLbKFyi/Ii7p91DDyIMsDWyptqoxpbk09WPp/2BoiKTLhGxR+Vex6lBS3CqCpIXyyoi5Jjbdjczh0Ryr6tRFTCMxOcBY6wSSbXsFbsvme8MRqX3//bz3v6kKTBeRD9S13YC+o2BCWNgBa+bX0UQv/b4ZG4DRa91MBv/4GOaCwbKMs7SLusRWDKPSNHB7S/hevZXJtB2pvSQuvEa0ba49331FE5eRi0lT04706Ybhko7sWtHydQQgEflDwwoLhm5OD67CC9hA9zwGGQ5h3rUWTtsWVy7H/snlIr9f5s48/kJKQ5ZuMOzqQRjPszEiFsFLC74SH82EjPoISsGj3LSqG9D5llIwIVHZ
 bOZgRnMt
 zciVu+lI7wJT8J8PkagS1wlXIHUDM86Sc/CMGCaoHkv1H4W2xCn100SV8pKXlL2DrJnPSOX67QB0r1LdutKqyZqYlG/O1svBeULvWBCsC5bvR0hWnRAeAeWAhPIePBzTJSK0DHc+EI9BcprI781wlRuod4VL+w1uQESmFUxBgFmKuTst4waR5D/Chcm3GntLBIEoRxInoGR0vfALf+Or6lt4qARW5cGRiUqRGOw2yAvx8wxjCQYStyGMWfXtI3UcNA/Tg25RgyVOCOVa4N/dNSM6E9J7sasiCFdKmp+U/7MRv1G4sjxb4VYLFuk4T9uVv7ZXRXOMkhQMS5xLMf+sUK4jpA/Om31i1XR398vVDWgZT93JaHmCO4eKKV4eL9n8d5SrJtSQ0Aw043Q1us543n0Zvpj/EL6d++JgvOck/cPXhba2mylEKEKHS3jOYhjpzt6ZhhjYXIE4TYimlFxF6cy/HlNkfeMu6ZJOVioqgdjaJASbCXOPzbVv6WhGxO3CFWj18/Hnw5VwK0hxDewv8BIjz3gEh0cRopkFsnO6RyjhfqXu0/GVyQ2pnFpMyklLsBPFV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> this is probably ok, but also we might want to look into having
> verifier still allow to dereference trusted ptr-or-null into untrusted
> ptr_to_btf_id to help with smooth transitions like this.

> Not sure how complicated that would be in the verifier, but that would
> be a nice backwards compat preserving behavior.

I have just submitted an updated version of this series that also allows
to dereference trusted ptr-or-null into untrusted ptr_to_btf_id in
https://lore.kernel.org/bpf/20260831092305.42062-1-tasos.papagiannnis@gmail.com/T/#t.

> But to keep things simple today, I'd just mark that bprm->mm pointer
> as TRUSTED_OR_NULL.

If you think v3 is too complicated, or that the trusted-or-null
dereference support should be split into a separate series, please let
me know. In that case, I will simply mark the bprm->mm pointer as
TRUSTED_OR_NULL.

Thanks,
Anastasios

