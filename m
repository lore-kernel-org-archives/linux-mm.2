Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF15D0E6FA
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 15:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A8A6B0027; Tue, 25 Nov 2025 10:18:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D526D6B0028; Tue, 25 Nov 2025 10:18:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E6C6B002A; Tue, 25 Nov 2025 10:18:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB2206B0027
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:18:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C1BCC0210
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:18:24 +0000 (UTC)
X-FDA: 84149485728.07.B6CF1E4
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 87E7340007
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:18:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ej5GDYwd;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764083902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TAsiLHds/qvfszqhkZLkqHZw/mWoHPv0/EdjTkOyfBM=;
	b=SdHl9ljVvy/mEUKosa8rLW4U7m5RvW5mE0weUWIynPNp63Q1KMsEtdxu3S7DUEut2OsuXG
	4H5pzkdL5u40mkoCUfZb5uAF1FPTFp4EnroKDqx6/LVL26KMgucnpIlyf5pvs2uud54dwk
	Q1ERX94MPDfblQCQkml82BnQ+yLAUpI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764083902; a=rsa-sha256;
	cv=none;
	b=L+cgHCmJl998Ie6E1JskiDLktWLZKYHkqUmb6r4QnrCBkORAt+ryJV0EkJGzFKgIRhomSL
	ep2LQuHQGwk8jU+XUds1ujl1V2p1dXw/d64DdkorK/i7az/1K40/VmMUwN4aovkkyFk5n2
	+EgJ7Qz8XlSLBKF+1P36Aw+rMJENHzk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ej5GDYwd;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64149f78c0dso8566560a12.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764083901; x=1764688701; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TAsiLHds/qvfszqhkZLkqHZw/mWoHPv0/EdjTkOyfBM=;
        b=Ej5GDYwd7r39GaE4cvddRSDPiM2kXEPmygiYgl2lDDMDyynGonHnUmWs5rfR7djrKv
         6rTOSk4GhOaxLumXVehk4dhhVmf20BTQTYAFTbU8E5O8e1aqwMx9SBe2DRVfGhvx1Rd8
         xVunlve/6XTyAZZ2o3lvIQxkUjm06bpysPjnrrNolPWZs/2udZzvgaAgJerH0rX9CiPp
         ZVNp0y62frIHagtktHoV/FfRf4fZet+KACppD2Y+CsPxbQ9pLHXNJBOoGjuh13c/6QAx
         NBp0p3y5oG5m1WZamHRq8HW3aphOsCwgwsvYRSME1Nf6sDEMokDxhaExti3ZCE4qd61j
         ZAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764083901; x=1764688701;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TAsiLHds/qvfszqhkZLkqHZw/mWoHPv0/EdjTkOyfBM=;
        b=jdtKVdmA658j5LdXXau8Aq4U5930QmjC9ZLuwTHdHv+QFekn7LlMbI/sW9nfa5cabL
         3I+lxsp3wr3R3CeIOH8uWHTjyB3Qt8yqkjxo7lX5HYWURuc0SzTTyJ6iTC4SBLX+RSTN
         VD6uP2FQgl4H/5J00lcJuzfD5MBQTsTxiyqi0mqf/ihLZB1ss9i7THn2XhN/E2kGCVwM
         wxWWOkn43hzysbAPxHjSzQwkYsd5+S3gACbLCcEuw4iwJposajgHlCrBe+Q0u58C6gYz
         YKzUkfH7kczEZzvt3CIT1Lxl/00/NwfNJuI0XB1kqJgJrfLKKj8v7Ph34XNLse2TDGcl
         Oagw==
X-Forwarded-Encrypted: i=1; AJvYcCXaHHEzNmC6pqY3RayFwBi9AxvxyQfcsUgpjRRbK5HiTTo5ysq5uoylLQ1h7Xtijcy9ry42+R7xaA==@kvack.org
X-Gm-Message-State: AOJu0Yya2gLhZz3xeTvaml/LxBl6k3yxSTowSHOgimJ9IHLBvPIX7s4s
	M+ztV1j1YqA1lR+05xHreAydhsdcoAme1ECjSwzWgDuLnSgekLKDNTiiqNgL3Jb9Hp/lkJIctGT
	hOkbzRDRN4dOLk54E4RnNgIfFmJaCLjN9HJ6Q/UZn4A==
X-Gm-Gg: ASbGnct7qHGZd+lxtLIarAdYfzgyikza67Pe3r8sfGOswDbP76ivvhanqzOdh6rDNWT
	I1ZEKv/DFhBUQIp/GKkHsusCQFfDgzoKkHVeMZKL9FM6zD9yO/7nM8pTmmbSp4rfjwf3R2CXIrG
	Gz0s+7+pqksnnfA7nGletpGEOCicZt/jTbLrcthEKPnz6u/lccVR9DOGWh8LQy0MWBDSL5eo6vA
	y2SyXYDcTf9YBwBRHpCBD92o/xKJkv7C0M+ZpgZvvqH8ZvQsZ5W5vFQWSjc7CyvR5qw
X-Google-Smtp-Source: AGHT+IE0DHidFTCdre2PEQZkWO+6fXHnDyl1XZap9xXWaDlhJTWELszauIifJNX3sVuiB93zZccT0oD4UK2jv0u/xGI=
X-Received: by 2002:a05:6402:1447:b0:643:ce6:a7e6 with SMTP id
 4fb4d7f45d1cf-64555d22c5bmr13732647a12.31.1764083900798; Tue, 25 Nov 2025
 07:18:20 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-7-pasha.tatashin@soleen.com> <mafs0tsyjxwoa.fsf@kernel.org>
 <mafs0pl97xwj0.fsf@kernel.org>
In-Reply-To: <mafs0pl97xwj0.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 25 Nov 2025 10:17:41 -0500
X-Gm-Features: AWmQ_bm8wD9QREho2Mnzi5WuSu_89_AomH92z6tVmxt4j7_zxQmibtYMJWqN8Vs
Message-ID: <CA+CK2bDAFgH1o8zo3NrD1AOtiSF-aqP17Omg0iaWr+_vSVtTQA@mail.gmail.com>
Subject: Re: [PATCH v7 06/22] liveupdate: luo_file: implement file systems callbacks
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 87E7340007
X-Stat-Signature: mrnsecw3r93xzd9q1n3noeb55ipwuus9
X-HE-Tag: 1764083902-143682
X-HE-Meta: U2FsdGVkX1/dr2hPYZ4cDXsFBmRqAnEFnEFtILH/fVURi64n7A+Q2uTGmv71RySQly8jPNe0oS4m9UarAmZFoaLBidY3IOlvyz5FFtbhSMG4oyQQyx330yi/dDFjp1n/SwS56fPPs2UtIBCfMRT1LDFET6u9mCciKgXV54DbIVbQBG1jsu49SEcWqwFiJdgFYyZs62F2rQClREvvQtTeYFyLLnE2tqa4eLtX+JC0Z0D2cokPYgme2S0fn8dxrGYNMHRmpvxafRdtJGa6VTSu/riO3Nltq4T/YTvcsYqZWpx64kpoKi6ZZbOY0wj3QcnJ85ZBoDq8Z0nTaoCB37LzcCHfgDB/01/PKqRTfSM1W12U2kjcEaU/WbCelaYPzDaR9jmRe4Xzg3SdJAke4l/7Thyq3zfSlCCrl05KYkOc8agXQFxiMiEr/7PF/iUSas5fXo6v73aDs3uqa688F1fznnWbYzzRCmm+RhSpmMrJ0KDlEzUK8PJ1pBjBZujr8vye+nRdB96RrfgFxXBrXQg/lRKJOmyPQaAKHRJxH53LuVb/CvShVRoKH70qvUWTOn42y0dUQZjO+Mgujb6pkDx/sCjsl1Lxx9UZfSPFpPfcw72wf0680JO8CGEKzgOZ0OQInW+TCljerGssCtJA4bwZMqu6AQe+RNhvaGmetSJevHOXfRkkMiMv0t4kIC2ohf2W61pH2c9/CJIBBB1ASGt2HHdtZLdgnJPUyZwZr3iEk+X5vFRttjLr/M689OqiKfLNGTr2NuAbhkRvR0GkRof1LeQrLejzzWToUgSgiMEOXnxkadqnWq0FpTZVYGhC99TofCoVLF7uxB/qJsZ24RlKPvfCOdIayMuyZ4w+BAbTalLiXAsoVUOy6XygDk/s51vHd4flKsEMSoYOrbzQZX26yf2ifxhFoj1lC+HgEmL6rWrOqddQQmVDlOMFRokD2DSZDWhLr8drfQq8V/klwx+
 /c6aMeE9
 vV3cXwCX2at21ftIY43LC34tl3qEXNPhKReRJzU8oWneWRv+DhlsMYJaD4uL6GS0HTwI/BM/tKw4/JOnD4/PAmwQ10pGZ4IJW1aKhKfnA5lBZNjKInTW+eIXbjQb7oMCJaYzpYOJQRYFSWYSs+JiRqLrJVlGi9UsxfFmxAzRtusu6cCzcLyo+Djhvd45Tj+0ZKf3OQt9LiYC01Sl2/3THzGuyLKAgoiJRdRvcRyr3DAMSa3fglcys+0Ujwbq8agRfQB+TMVBYTSaht3lWN/49Bem1cyHJLA9ri3UMix/SPeyuvnRvbrLywOktds5DMo+LA+zvTlCVR/F8eY8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +     if (err)
> > +             goto  err_files_mem;
>
>  Nit:                ^^ two spaces here.

Removed.

>
> > +
> > +     if (file_set->count == LUO_FILE_MAX) {
> > +             err = -ENOSPC;
> > +             goto err_files_mem;
> > +     }
> > +
> > +     err = -ENOENT;
> > +     luo_list_for_each_private(fh, &luo_file_handler_list, list) {
> > +             if (fh->ops->can_preserve(fh, file)) {
> > +                     err = 0;
> > +                     break;
> > +             }
> > +     }
> > +
> [...]
> > +int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> > +{
> > +     struct liveupdate_file_handler *fh_iter;
> > +     int err;
> > +
> > +     if (!liveupdate_enabled())
> > +             return -EOPNOTSUPP;
> > +
> > +     /* Sanity check that all required callbacks are set */
> > +     if (!fh->ops->preserve || !fh->ops->unpreserve ||
> > +         !fh->ops->retrieve || !fh->ops->finish) {
>
>  You are still missing a check for can_preserve() here. It is a mandatory
>  callback and luo_preserve_file() calls it without checking for NULL.

Added.

>
>  With these and Mike's comments addressed,
>
>  Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thanks.

>
> > +             return -EINVAL;
> > +     }
> > +
> [...]
>
> --
> Regards,
> Pratyush Yadav

