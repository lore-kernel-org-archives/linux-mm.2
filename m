Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A7E10F3DCB
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 04:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE596B0096; Sat, 28 Mar 2026 00:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5FD6B0098; Sat, 28 Mar 2026 00:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBCA6B0099; Sat, 28 Mar 2026 00:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1DD46B0096
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:03:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D3DD8EAF1
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:03:46 +0000 (UTC)
X-FDA: 84594128052.19.2ABEB5A
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4846E1C0004
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:03:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nw3OPZgZ;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774670624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B3Zdm9QRebXAcvnQwXWCkI4HeWD2IUP+mu0t1G2C/Dw=;
	b=G/fJDBYOygVPLQO3UInrfvUoIRP71Fu2zMVxmWfETEUsGG8Kx2FKap5DfUEPkbcFZkPmAQ
	JyiWvg1kD0ZoDirElMQczZ7TsQc3a3JNBc1qDQ/rPB0LFbfssLXK2wYcjiNUkBPdR2LRzL
	+P6hK+QHEBEhUh+CIsxAPgNJXD4YWgc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nw3OPZgZ;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774670624; a=rsa-sha256;
	cv=none;
	b=z5C5TsPZcK+3tmUjPersPNMRf31Dq/A5DQIVJ19v92NpoWi37OBuhnShXbTyc+qvSXF9hh
	/bWU+6+vgXBM5MeArzeGi+EYI8UioUXDtQiJq0QVxS8hORaPFq/IX9ugKOwjauslijcgqP
	08rnuDqf2xMIQ8wlReJdVl/RbBZ+3o8=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35c16db1b53so1545258a91.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 21:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774670623; x=1775275423; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B3Zdm9QRebXAcvnQwXWCkI4HeWD2IUP+mu0t1G2C/Dw=;
        b=nw3OPZgZLKqBDWvQpQukwA1nM02H/rJnQkO+/Ppi6Z16Qu+hVGH3w9vo76hfOsGhn1
         DGXCQT1kKx3BD5Wiil4yPqr5NUjedSV4YiBpPHmkOn/UpDPNIbmbCVjYii/8o1z/KJ7f
         BZiA2NOg7JmyuRBQdRvrzhOyQYayFiu/19j+6tHBtF0a11nYsObFuQVJDfAjMJPBmW0l
         oxNPo/LaRm0qZtdFoeg9iugAVXnBLXE5bOhJH+DR8gErLaNL7Mae7xj4gBbK0TbTI4Su
         wByupCSWG71SzyExMIE8aFPXwaDjSUgSY5KR/5Kl8teCzhy9M42Ccfde1wIIpRc14gyM
         UzZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774670623; x=1775275423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B3Zdm9QRebXAcvnQwXWCkI4HeWD2IUP+mu0t1G2C/Dw=;
        b=mBdBq4i4aw8jLql31iFFZ89QiaohEf1Zo3n+TUhj7gHiW5v9pXvDWmv2QMGAOtY48h
         pqVGiNyAWapHyCewAwXp5LU/0PFVkpaFAsQuhHZUakYxoTEpsDrGekBUbeZb0FVdYuSw
         nzhJm4QCk9caZMIyqJF3ZvARV1WyIJIB9B14nk5RltdCHdOSYyUAeqxViWVnRSt8IouJ
         +BSYgmm/DXIycFtxnr7X3cbWvGmuXNHuKDFsv6useBcBELBxZMRKPYPBtzMLY+bgQoTJ
         RuwRFb54S62ITTc/7yux0rLAVna8ddXyk61AjoiRe1+nN0pgt7ptlzsL+dD/PJDcUma5
         vWFA==
X-Forwarded-Encrypted: i=1; AJvYcCXU1VH1mITzgWQk8cxJJGWVCLgBcCVOoegeFBIv2Ni1xfIRP6DCLfAgsACIaogrwTeI6MP4p8pZ8w==@kvack.org
X-Gm-Message-State: AOJu0YwqPjCpGyCLcQQAEzESAPZP1Vzyi/mEA4EPSjTxDrs7Iy2q4Ixl
	9gZkbc5v9lyxgzyTD5QPtTHc5Ryu9+Udwd6rCAO4I8fdw6ds6bOPAzVz
X-Gm-Gg: ATEYQzylpdfxg1hG10iUFAODTRWJkPmtzIzfsDwV721Wa25AjRSwWZfzJWY0xI86Zmy
	ruTVU35jYvpzf8v/hbAucCpdVOdXZB8+KVX83jO/41JP/H+OgoscPlz/e0qOJk6k0M/nPxLkJ27
	9L9Q9JKtip//6xk21RHNQojL2mBeXPn4K/Ye0qUxsMo8Acopjz6Wki4r2abJQFB0w61KNpNIxd/
	xZEm+gjGk0lD1ZNtwA9gbUGXHb8fYA/PEwZDEEnTt59WnUcNRQ/u55j30K2gQnvO9UEcLmI6NqQ
	ZW7DxzuPjPKHRCPxphJyWJJzDLl1goFbP96osHX4hsmR0hppln+FJP2rVlQ8eIu0OaXUmXA14LJ
	Dgiu3s/4QexK2WQ9w+Olhfpr1IIe2sSkM7hfl9jlkYoFrr5OHxy2XJcKnpsYgQ4zghA3L2Nm6aP
	6uwkW6c9kXod3Zkvv1wj8EtvOzcNjUaL8OvXiKqkFcmlhMSw1/Bm0=
X-Received: by 2002:a17:90b:2e83:b0:35b:93d8:6aaf with SMTP id 98e67ed59e1d1-35c3005589fmr4818265a91.19.1774670622949;
        Fri, 27 Mar 2026 21:03:42 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35d9509cf33sm621254a91.13.2026.03.27.21.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 21:03:42 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v6] mm/damon: add synchronous commit for commit_inputs
Date: Sat, 28 Mar 2026 12:03:39 +0800
Message-ID: <20260328040339.51871-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327135939.4085-1-sj@kernel.org>
References: <20260327135939.4085-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m15a45cieitjws4mqdna1675yoyyyq6k
X-Rspamd-Queue-Id: 4846E1C0004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774670624-997603
X-HE-Meta: U2FsdGVkX1/Y4g8+49EooOcBdMjs+Zjn67Ucw/xFJ4XH0mxbv8K2vUAEePmW2l65jo8ZYqmaqOD0+lOtqWv+DLc6NN3DS0PtRLHPSPjmEFv1awlXG4HjJHKxVsGs1pwbirZO9SQYt/BcWVwp/O+8KZ70rzB8/ep0CJY1L6J0fcuiQ6nt1HP7/xD5lYvQ42qd83oIF6J+IMBBlRy9TozlFZxbCALsKkYkfu7Y0DAXoeAsUfqrUmaJg60KEwrv6h+lS+k21qaLkV0TGtpCDOzb62VcfOLtniZGqP6IT+In4HU3W4mTS9/a6eYwjEdmeBXJtW44q+15u0eKpmAi2l7mBmZJHlSkOraRGG4gKHxNNe7JtG5yIn5lYfDlSxMBQn5bG/Huwj+Pj80hZdaGtZZ1nEVE0sTyVJhBNrN/J9aW3+Qn9dCcpBGGHd5NX88jT79ZQGla6PGw6G4e3owmDoRQlAAuCb3MIMrTSCeV28/lvHIXbxo5DuOI7fHvlQysCH14z1YoRqClik6U6DN6+b15144qBsn2/iqJqJtookGI1lyiJ0jsrK6RzSTZb+GVH2OwyqRsdej1670ivbc+651yXWz3Qzl8xe+uaiRyyxb7g7A6p7P/YFiXNJRv6kDqq+wpBpnCLqezhNBtZjClG5MJypKNBMeOrAJO8gb30GFMDvpP1TsspSi29OUDxrHRP+nlWWydQTblCTvoUP4bHm4CaFKFri3D/Z0i6otISkR6oemnx9pK9kGY3sWEcFJDkDPSjXTOce8BDFbHQM07VeVfGMayQ6TBvmpvljRIVxjj4cMnmQcyyr9JPRyKR8kcxx4/XB70QZig2oQK7jWkPnOFN6+jGhwCKX3V5YkiUBCFVdZ77iJoSIeAObXIOO1fJyqajkPgie+m8KcnkWd9xt20Dpd7GiEzfQJcawSL1JxIcLMP0dm00MZZO7N8iIb8OD/jXzAkwY+eZqccio2ZQls
 5o/KxrOa
 moqJo9q1cgdWfyyfErJgXq0PpREYx6+pHRb20hj3zNxDBs8I581zeQDeDBQkNnBeS3Fg948sCp/Xs4SmAkqwPaRrxhhQKVz8vyhcrNGrsVLmcPywguYCuSqqxAkcFjPFpsp4wd9RkQcpo0kVqQt1UVkUFPKEWyT6aCXK+qJ78I0sm466ik5VlJZm1hKEbH29E/14HIQcDzzRArSb2tyj8TURziYkSyHgxsaEb3/YQe8/QjiDLkod2Yrh0NCmmrMb6aQuKWWBdeOmID5krVRoEMWa3Xw7CquhXrL1I3aLRaNImr4D8B52RaZ8YdIeo6Xcq5VEeI6VhHTGcypmA6pR8LgJmJgNWHjijSnuZ1kUHqYqn7sX1CsQF+5U2xIHPh6v4/b2qqQ+LQLs/NTYOPBgtGdFcSk4hFjXEytVZf7j02G3ik2i3+SJja6YhnI3rflRtIoI1syYdT5z7Fp5Y/MZPkqQ1E/vSPGM8zWP1FJR/aknjcEY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +static int damon_lru_sort_commit_inputs_store(const char *val,
> > +		const struct kernel_param *kp)
> > +{
> > +	bool commit_inputs_request;
> >  	int err;
> > +	struct damon_call_control control = {
> > +		.fn = damon_lru_sort_commit_inputs_fn,
> > +		.repeat = false,
> 
> Undeclared fields are initialized to zero.  I don't think we need to explicitly
> set repeat here.

Agreed. This change can makes the code more clean.

> > +	return control.return_code;
> 
> Shouldn't we return err if it is not zero?

Correct, I've noticed that as well [1]. But thank you for reminding me
anyway.

> > --- a/mm/damon/reclaim.c
> > +++ b/mm/damon/reclaim.c
> 
> Same comments can be applied to changes for this file.

I will apply these changes in the next version. I will remove the RFC
tag because I believe the high-level design in now solid, and the
low-level details have been mostly addressed. :>

[1] https://lore.kernel.org/20260327071410.73642-1-aethernet65535@gmail.com

Best regards,
Rui Yan

