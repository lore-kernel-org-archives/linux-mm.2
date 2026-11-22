Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C99606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w7yvER8f
Received: by kanga.kvack.org (Postfix)
	id 8A3B46B00EF; Sat, 21 Nov 2026 19:00:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 855236B05B0; Sat, 21 Nov 2026 19:00:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C766B05B1; Sat, 21 Nov 2026 19:00:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BDE66B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:00:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADBF71C3F34
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:00:35 +0000 (UTC)
X-FDA: 85460798430.07.3BBF361
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id C3F94A000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:00:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=w7yvER8f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795305633;
	b=yK5CxSAgfjqTfBNjTIpRQypmMXcg+qyxEUpCeDC0OwoGuVqXaRX3lNR5F+K+e5OUY/XcVc
	W4Z7IPpdZfumUNODhQXgNIlOfC/+Z77QNc2JwjMb6TaMyYvO2TlGyMq71JFEd2bUdANzI8
	ZHS1QRG2PbV0DY6SZformLK+HAihfuo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795305633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oX79inJRzxgZwR0Tcie38RtbzYQdIj/eTCukvbMNytI=;
	b=wtu5mSAcngM1s9SBpT13NtJyxsahiWWTtJsmBq7xM6W5l7BcqJ/NPDp5J4v/eMBlhigcsB
	q8aurz7hU9/NUZeZoSy2yvr1F0cM9KIO5A+hIgL3OIZROs5YDzuXPkgEwkCeJy0kHTBLQc
	z8hd2qCdUhC2WMEZTzMOdhup6VpqiFU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=w7yvER8f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-843b6f8e2c7so2101954a34.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795305633; cv=none;
        d=google.com; s=arc-20260327;
        b=BbiEpge5oHOY3XFAltXkVurb7wStzBg3IsVPydHa/ONLRaFytOZD6c5ouNF9qYnmSD
         8m1wI+JXuH7thkxI7PBiuOz+NWoH+8jGMQEDUt26//krubuZh7zeLZtGSbYtqAHvHRr6
         IUNfB7C/kSlEV5VE0ZeD6pEFCmwYw8klXhIp+FuAdUj6TIzE6KJtnpOxdXlBqczkCNZK
         R2aBn6PyUbW5JggYX5rALcd0Fd+1Q9pHXu7zEh6+xacV2m/4PiyVlaGImtEPrhSwbwvX
         uW9pou5j8z4msjgqljzeTcEW5y4gTqmmTzdTk1Sfa4L8zpFyfg/z3YD/Se7Ykex/kHk1
         d7yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oX79inJRzxgZwR0Tcie38RtbzYQdIj/eTCukvbMNytI=;
        fh=v8Kx8j+IdqFrxRwPimVPDcSlSwAGjOQPbrdtG/5LlD4=;
        b=ifsXEfYgOugt8qrX1KZxlU0cffrgd6QrDIbz3lb89vfenUtPzV9g6z0M/8VEJYEXDB
         G4b15Q5RorvIrooXIgym0WiJAHoXY/y5QDH284yCaLXUxZXdsM+AAZneehkoUVYNoCm7
         QI0sN4sYJFaAgTu9A+O1JCw3wtjaXfO8dn1PfBIq9674053HYtfG5WgZuN1xDCWF1DJn
         klS3+UvXrxmrW4vVepvZJPbCltb6vckPYWft7rx3jNaCcr/tvFcK6oJJuP1+M7ZHNxhx
         8TTmlmPfbWeEwetqqLHsO2UjSj7Rc1iRcUXO3IBQV0pBZfSI6fQMcUte2WgqhtKY9jZj
         S0/Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795305633; x=1795910433; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oX79inJRzxgZwR0Tcie38RtbzYQdIj/eTCukvbMNytI=;
        b=w7yvER8ff/yr7uTDFwBfAaPssy+qpevegQWiXHZjnODyMiVGuAf09+urMQYUgm4wtv
         zGCprDIgZhyMvALFdvmflSYHVqQiesyvFMhGHt/+Yd7TfHGO9HrdKTTkxHe7jYGGl7fG
         mxjjjle+bw8vP8p6StTnt996LEJKp4YVCO9ZeS7EAo+rHpabBA3nYd/xEyhQ18afqKTr
         Hqd9QpkDGOg8xLXtBx7J52m/u6aty9P3U1T4X1fS9wTEr+TMH9V1Et+mpg639GJ9HvUF
         /H4yfFTVi+TvkJ7k1wVYxC9KONgdRn+usAnpvJyMTcY74YHDSQ/rchm1Jt8p6g0/W0EP
         OYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795305633; x=1795910433;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oX79inJRzxgZwR0Tcie38RtbzYQdIj/eTCukvbMNytI=;
        b=yQz4KY9DkOQXp8fvrARACSr3U5f191qFWc7mRDOp1P7v1Yv2k02BvhDGvz5BVGjOwn
         nfuXJb6fwOkN2xS9sdrpSMvDEjsfssPr/xKWSw4ruL3HchQ69jzmPhzpd5MtubdCo/H2
         bmqJ7/RorDdGqYAF839QbYsk6QzkbFCubnOVljfdS8xYsf6im79c0Y2TskwHjIb93tpU
         4GEQfT/iFiAemAal4LvwDnbooEGvi3LJizKo2j87EVCLPcmM+RyeclAw2opWDqEvFl9d
         D35yoYJAC5fZejnkwB9zcszpuxz7Qv3Z20T6ndttcGJRqpHjMNbRQkPJPiVBrTAXOrmK
         q56A==
X-Forwarded-Encrypted: i=1; AL+hErFldpIEeBQ9ftueYW8awICwu9anhxuN47MeBTCRPfG5cM0sul8Xwaw6kj+Wmy8pgxo5T0Bm18rbdA==@kvack.org
X-Gm-Message-State: APuU4Z+DuROma5mzx3QHLLCZIJH0TXHwZI5ndCDCVyCrwIQtCS6vtFHO
	Ded93oEIcQaLTWnV6cft63HwS0KngiCTbk90dGfHv3meCQjCB3ChctfenuejvwrazN04yk4aP79
	vnmUUg0969q6OscsZCI0c3ScE2uFciy4=
X-Gm-Gg: AZFdTZdYtWBYHjD59QoKF+ObjIeS++DW/z7lnxbiLqvk3QO+dSpHSRmENK1Z0mYDCw9
	Lv3riaucUw7VjFXxVr/UcV5cBofyXrEeyDVKHyurbhjLqIThAgb1CHa+ZX0SzqZPo+xebh99QF8
	sCYDUxeIUvyO+krddcFOYERKwhLFh12ktJP/XmsNQazic6KVq/VjLZdkI836i6jd/9pUTNR2dVx
	QO44phi8h3cMxeocla7Su9GZFx6K3Tl/eNWRtvcVqw5QWMxzyEDgY43ss78+gFHL/27xIapTU4k
	wDFYP7JMjxrCRZAAVS9m92ikZ26eA/gTkOh3KmVjXxKKTmS8sZz5V6AxZr6ANJ2XHH0eKqz5DYg
	ZuXUQNZGEtbbcI4iJbCSHipnkUdj7ZWG3Kkiq
X-Received: by 2002:a05:6830:6a88:b0:863:3a1a:91e0 with SMTP id
 46e09a7af769-8633a1aa039mr1043518a34.10.1795305632770; Sat, 21 Nov 2026
 16:00:32 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-3-shijujose2008@gmail.com> <20261017055852.GBatMOnEl66YObvU5k@fat_crate.local>
 <CAG4KcR+NOKHNzg6FN-oLLHgUxeitZHKXg9cN7dz24+Ap=RrwSA@mail.gmail.com>
 <20261110071729.GIavLFCfLKzPx8R0i0@fat_crate.local> <CAG4KcR+ikfQEBjCZiNJ1CUz=u3Gtbk_XDroA_GQqYpgO4Lo5Qw@mail.gmail.com>
 <20261121194030.GBawHzrrCNCMpfr7Gx@fat_crate.local> <CAG4KcRKhE1UXwrhscUdSpDJS8R0t7kWp8RXZm8j_9yXYJSQ2KQ@mail.gmail.com>
 <20261121210749.GCawIIJcidCeWs3ij9@fat_crate.local> <CAG4KcRKzXNsvBWuuU2_aX5gO7u4vgKAK+bkrB2vgEFBGu3WJCA@mail.gmail.com>
 <20261121230942.GDawIktifTKlYhUlpB@fat_crate.local>
In-Reply-To: <20261121230942.GDawIktifTKlYhUlpB@fat_crate.local>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Sun, 22 Nov 2026 00:00:20 +0000
X-Gm-Features: Aa3M54qnCHZib5IMTc_EQOb3UJ-aKnrHrCYP9h8mtw0fwRaNzLI4HvK65GdTkSg
Message-ID: <CAG4KcRJjU9WB7o0woOaAhtWDPoaL-52T8MUmbYJ9iC0EqP93Cg@mail.gmail.com>
Subject: Re: [PATCH v23 2/2] ras: mem: Add ACPI RAS2 memory driver
To: Borislav Petkov <bp@alien8.de>
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	tony.luck@intel.com, lenb@kernel.org, Yazen.Ghannam@amd.com, 
	mchehab@kernel.org, ashok.raj@oss.qualcomm.com, jic23@kernel.org, 
	linuxarm@huawei.com, rientjes@google.com, jiaqiyan@google.com, 
	Jon.Grimm@amd.com, dave.hansen@linux.intel.com, naoya.horiguchi@nec.com, 
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com, 
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com, 
	gthelen@google.com, wschwartz@amperecomputing.com, wbs@os.amperecomputing.com, 
	nifan.cxl@gmail.com, tanxiaofei@huawei.com, prime.zeng@hisilicon.com, 
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com, 
	wanghuiqiang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: e8hrobrh7uzwm8f4xbknhxzxyckmxntt
X-Rspam-User:
X-Rspamd-Queue-Id: C3F94A000A
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795305633-122107
X-HE-Meta: U2FsdGVkX1/n4UJDlPBCmgjPhJ+pqly+fUvyrSGOR/J7jDR563Rr33G7cltXAKIeax0/125/Aev8WfeBlbGBr/FnOlPKfVbitwsYrViGyvQOdDYs7d6bF08nsx/Ry7ShCfSFL/KOlXX7uq/RPcvJu5YxKrmtaDa4eG8N8Y/X8yhWeDM5AStfeeUye0ZFSVMKTX7sMuzssvCIOiQKJKQZfxbCW4vwvsoAV+ALtjCCMTDmWR6Xd2kbzK+4gfsPx4a9NYH7ZtTZpCUGPwCMAzFJztcanZMnH6EWjLYulWdi7nkh+tGAk/oAoQOqkF0vdrtTlaUtDx8ys4OBjTSXH02ISw5+BBj1p3M8+o+dwj7UUFdXtziVyj0tAzxH5xJ/DgGT2oj9ftLH0XhYhb0Ele5hbiS/XEsBQSv4XnKfImY2FwhfcD0VPyvRsD+tjOTUaQzVxDWA1f4atS75Ie4K19ojYSm08ne4BBvR5RvPu/X7cp11baw3yLfyCMN71gYgDzfuylRJWMBHdKUxuAGjeM0j7Hqur3iRFOZTaUGAFbJszf8rbS9ARZpN4syfV/BNrDTwAx1hM8BWlnnLHsplvZnbvqJ4q/NFTjFEWYKLZa95hSeLn7xE2rJHra+oEH+wpmuYw+SkIQnuv9gX2W3xsdqQnCJg3Jat1u0h5xqGKxy9lDVCOYCyIm1HSweQFwbo1lXyBg9/x85HsfF2/dBpjUVW+G+u0NuSCJ+B1DdJ4r08UKyX47DP4xE7hiTB9rb8WgEaPbx2HDHLt63SoOPHeLKQlNxp/Gfdqxhjc+Znzegtk08b5y1OcPRFdDjIQZNeryiI0hK4ti9L1qQC8/8HRW8wu52LAscnNse6DPY9lAvXeRBMYgZpj3VWqI1RVJRelawBIlB0766BDYETozTpfmu7WUVzNuormJi08DtFI6TkDsq4Jl9tT6hhO6pua5KuQrEfNYHxmQgKaOYDhKfyAgR
 4HiHzNvY
 94Z9TveJ8d/LN1yW4UCPpvUbmSjqrVvrjxDYcMr0cFFmp/zyeXnr9r6MzLRsHxUpzkmW2jKyT6cyrANZ96qeJbsie6GOJy0iXvfolVu7qSm9IV8oYy/xcrvJvK8NNncbDFVkYpXUhoSGJvDBSwHpPQeaI/zrHuDkyA3k8qbzdcDC5Xw2+La/YAZz+7aLVb9VJPs+IO0CTeUFcmEk0G/w+4ip/pBTQciyQKEPMPyONGqONtJcwVXeQvD6OCUCdIPpDRYxGxGO8JUT2LWQpIi23F9X+3kE8jZq1BBkDA170uh6kKt38zCsDGvK6Nt89uI9Q2cszzeEq0KOgXbupSiuLStBo/Pa9cb+Mc1U9Pf3ZyUeTtKkYmLeF79rz/ndhow9b/AOl9z1iKhrrTUIxWM/NQ5Tgg/z6JYcmVixLL3aLXzkqvfLPhrl4kOk9EYTPdLPMsP6szkUo7dA0SqzijjliRdQzklIMz4HogAzl9Q1Xg7j+NuWrjIycxZmNITb2X2gs8B8VN8/4a93d6cZGIs30dl2zuDFvCr0qU3e0i47AkLVI13UrowMZucBE3NfUXX62Qlt5OVSj8mCui6OSvoG7SW3F/byu585EIjbXor8X/DFkk5LcAKomGJwH4JSShvR2K8eCQplmQ1Cz7pjVSGvfe9BDgEN/T4CUblHoR6BjOSeeSAxvifzA4oncKETlk/nhSbsHIET7m2G4hchWbzZwixKOC4RSr7UIOVU7MvRR5gsDDX72xVuS5h/05Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 11:10=E2=80=AFPM Borislav Petkov <bp@alien8.de> wro=
te:
>
> On Sat, Nov 21, 2026 at 10:24:28PM +0000, Shiju Jose wrote:
> > Thanks Boris for fixing this and verified by testing.
>
> I cannot test because I don't have the hw. I rely on you to do the testin=
g.
>
Sorry I meant I tested with your fix, which worked fine.

Thanks,
Shiju
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

