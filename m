Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E300CC5AD4E
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 16:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B58B6B007B; Sun,  9 Aug 2026 12:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98D7D6B0088; Sun,  9 Aug 2026 12:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87D056B008A; Sun,  9 Aug 2026 12:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 509776B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 12:21:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B48C7140596
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 16:21:50 +0000 (UTC)
X-FDA: 85082247180.17.C2A91EA
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id AA8611C000C
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 16:21:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MV0RSpIk;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786292508;
	b=YU3vlzvVf4PzzjpnRSYMGyw7vugz14OwMN8UoNC7fgfFrL+6OL2jhKNvVp+Fq2YvlLaL7o
	K/jAJ+hffy8dVbEgQYzQIyUaesEU7ZOjZgXqKDySQtK/gkog57QFHsQTdUq1Y7y8KV4qtk
	9oPMKflZ8NnF38iZ/4DGsWe6ZF/+cGY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MV0RSpIk;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786292508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4g+uNVEIUaafW1jVJCwJcqut7w+vaPKEHq4aK6RYbgA=;
	b=gFW3DxWOYr1W1uE1R61fgUPMgKTcjvXbhCht4++yKtKDG8F5vvh5RKMYdhosU+mzXUE94S
	iivnzQlEFgqBls1QX7TlqNjpeg6lgQhHTdVldIfn6XB805gFJhCpt9hU7JZm7933TeJ1OI
	ZPPuN5ZB1/Wz81yCWXAlwRb09Z671Js=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e9ecd7216cso599333a34.3
        for <linux-mm@kvack.org>; Sun, 09 Aug 2026 09:21:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786292507; cv=none;
        d=google.com; s=arc-20260327;
        b=srporklfinJsH8zIpbuRWr0lXohxVoyCb9L90W+pW03HsJAmKd2fIRxDhxuKdrrY6W
         N602wjELPcQoT22oO8ZuYG4krLPyZmlR8kn1aIqZLMI/pgGHm5pE3RNRZPwFDdkqaQtc
         UAK+nX01nRZsmYmrcOUWrJtkkfdnQDzRbCxsfgerpXPwnxOKX5ibWG2x63mXhfLmT+Tj
         DMgjtk6RB4Ys9r1xZ8sR/NtMa26apqmi1/Sj9XtqDyHV2yGZDjrfWhQHDcka1sRNNDW8
         N5V4Rdgq3n2pSv9G/huDvquLERx+H5w0gO3TssDvq9opTV5ADEQPsiftCGohANpQDIkP
         JOYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4g+uNVEIUaafW1jVJCwJcqut7w+vaPKEHq4aK6RYbgA=;
        fh=4g8s1MxfM9+y2L6ucnblxVYbkd0QS6Y/miwVvH28MQ0=;
        b=JUfXcVpGHboWB9rebiKgOTwFJ5agnmXsS1+BmiZ1zoR0QjVMMaZ058aKwKa49B1Mey
         k3L43LhbSDaDen+46YiScQhirXZ4SCpK3S61o/mKj4qbH3NcLkW2eX94/g2m+VASYZTM
         hbF4109T7CBfVnd8u4CH8GfZV32srGyF70qpK3wDfDMpP9mO6oOrczkcovLoguDVx8TF
         l1fHyKlfk1m9A5qEmb5kRFfHO6+BhQOUtqwKBaWOsWzDo/35pYhE4ZjSDF8rfs6Cr+n8
         OMxvvtBAENpNi+C6+dZwieBYtzgQhYsR5txSpTGrMvpjGX9K3H2MDyUvS9z+hABzTXxb
         zwWQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786292507; x=1786897307; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4g+uNVEIUaafW1jVJCwJcqut7w+vaPKEHq4aK6RYbgA=;
        b=MV0RSpIkmrygUMxSLD9Ccf3jMvxqovLsuBliLcdGXztbdP5cEEJM2WilrDN8nG7pta
         3hT4QotbZA9qqoslccMZ4TJrd8g82Vo1eMShe24r0ZwDSlzvOSEw/7XibZpSzHS8JsBt
         wylfQq6Bd4iuXYRZthOEv2QLQ20GJLFZYfC9OikqYhA/RZh8p8hBZde+dxvn7mIUHReg
         rezfZyvcHrsZjIttlAEnaLo37+uTCZQqR5of2K/wNGRjDLTlKjsanISZlIJPRvSJFDUf
         hRBNK+YoRj1Nnm+eiHfHqhzEZpE+9OCItvYv8xiyjgvInBD6ULKpt22tR4mMXrfDti/+
         mWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786292507; x=1786897307;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4g+uNVEIUaafW1jVJCwJcqut7w+vaPKEHq4aK6RYbgA=;
        b=gvzThUPj/DpmAehgDNlOmSTsAcnYqhJxBCCIJmagVPZCI7fEEpjF6zRDaQ7jccMVPz
         uApoTsAp7QrwtSGzNguJhnNpYkgzj9ZR0Pzdhw3foYyTHQtcZLw4puyi0ntRTHxNwvrw
         MK9lv9a7eFcMLRKTWzsHp7o/AVDiLVyanZAMwmQ0IwZvxwnazyowZ1Wy2y5TMW8VbDaH
         Mnx+XK26/32Pco08I+3OJBiWyTlPYQpfAtxnertyplDvAzqE0eE6nxQhhCrGz3zOl3Uu
         73cep+Z2csLGLoDX1KwMwoYW/EZ177c9S+rVa3OPukyGlb7zX4Z7kqISrjR/nzHYMjUs
         Twtg==
X-Forwarded-Encrypted: i=1; AHgh+RqoUGLcBuCYLy9ZCyfJd7iSTg0w3BwHBUY0bPgwi+u0VRhTcSFu+ph8LBQCJ1Yy2vethzA7eNBGLQ==@kvack.org
X-Gm-Message-State: AOJu0YyKbyNv4lPAsbxYCBtVVuyqDY3gEKD0CmEBSxrFa58qFOi+BgNs
	jF8Hwad1gA0iy4j7ZgQ+Jh/vPMeIPnbbpbvpPSK2kdN/3ZQCIVAyrCvpHnABgpiQlPDklF1rFFV
	8GGVpA1jJeU7A1mfLgek/81FTGnmhykA=
X-Gm-Gg: AR+sD10IvKDGu9IH5wySuR0KJlZvZySISxHNiPIwrNM1uTkHKeMkQeaQto8zYNH+RvB
	2kpH0iSpeb+rE4QVxk9KBPGdXksVL6kJDcyY0is+KeIeQY0bORCkRBvGBSDNA7YlL+Jfbftse4k
	172cPywSoPjFhQraCKoQ5HFWDNlIJsYPqjUyMoSe7Ynwyfhfw5vVTd/SIx7JWf5ABJPyDyk5nyj
	aJTfIVtSs7d31HxsnQOC2FrHW7N34KFXu/+laOUB1B9DcV/nIyUnaPDhG5vVdKFc/LGN/oBZA5n
	//djSpGW0iz4flLdZtRXHGm1cBH8jQQn2AYvz6pwPyb0
X-Received: by 2002:a05:6830:2b14:b0:7ee:19dc:b00 with SMTP id
 46e09a7af769-7f3690ab85bmr9122552a34.3.1786292506403; Sun, 09 Aug 2026
 09:21:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260726212812.89266-1-shijujose2008@gmail.com> <20260807055952.GIanV0WDlB9-eP9VdV@fat_crate.local>
In-Reply-To: <20260807055952.GIanV0WDlB9-eP9VdV@fat_crate.local>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Sun, 9 Aug 2026 17:21:35 +0100
X-Gm-Features: AUfX_mwLW-hapdu2hs4DMFMxwFy8InInYkZZJQTUfB_9HQ0CIhdHPAN3xmR9s3U
Message-ID: <CAG4KcRJcpLREkbmOEEw7nGD+_PNOd+fWHkODqfWo1M8hmxA_Bg@mail.gmail.com>
Subject: Re: [PATCH v23 0/2] ACPI: Add support for ACPI RAS2 feature table
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA8611C000C
X-Stat-Signature: 6qkqntwyiogp31cgm9zi37gpcquxn4k8
X-Rspam-User: 
X-HE-Tag: 1786292508-165257
X-HE-Meta: U2FsdGVkX19GFSe0gNZxVPn3FQsrEkyoyYqImxe0JKOOUgpShlpXQhCG6Jy9IL0i3cO5gtLt8m3lnYo5AjyCgttKCpYMycoLPQUIGfzLPqTu1c6nVitalQqD5f+kzjxKO0HMYFdXXkcasPfFUcmU2ybYgO2ZiY5AoUuh2haKvpzghaaBKKyl9ihc4ygRqNmSNiZwTtcw5n8iJSB5e7CBpuwjAIdO4QPxS1ZurV5yLUDvDj0y1UhuaHfhT5oVI3ojGfobe4RiqWhd9/jY90n7Lan8kjs9YRBH30z1TxD15z4B/QM3PgMfV7gBWZkiuPS+A9RQYLM/J6UsYF3cQxLQRBKEeN8MZnKShSQOj4c8YDDUh9CfM/VfU2lZh+jBxGkIzt3rv3/5T4L8W3yNn1e3gzMXJsAFSEU5ze/3CfDP//xMFViVYfuzB3V/mqeZfS3PLoz4brPBK9PacjegwY6RqZKZMgxGpoRuiAV92lCrCUa8IaiLMZ/E/ai9ehivWJMFPApMDynvAIGaZN0Wk07rVBHI9/AmYPbkQnz9iFAbX19BDguCmv+aLTaEHtuJbihhDCPTJZUO6U229kLkn2A/uYg4gjV5Q7gkNqIynLlVgJPxGLMx+Im1UtYd8namZdfc/O2bLiSt1/+WWxcbZ3073nqF9r5YF8AT3lVPSg/0CG0PU/WW6hHvMcnArCT1Vv4rY8NI6y++l6NZvDTaEFaYqGpQae5xlaWJcMsjlnsvNPuANa0LbRBJiTTu3kp1SsPVBmw1LHztLLwfi/0ODBcbv0dvXwVM46OB1dXiaqqlN8WghCv9mj1Lw11IbY44+iZVqus+caHHAwzmrwVX6kmL8LAF8X58H5aSELSgN4HN6GucOrSLCv6mQ39FJ3neyUIJ1wyOKU6AxFhQCxh19w+1rEqsucGKbrvyBHmaQdU5lvRMrM66ZG7DzbQbBKOPD5tVg5CKAlBX/SzkEqqfh8o
 yfW55i4F
 v9u8phlmnX+ndDS4DIqZf3pSFS5XAp7pKhRIOljqdTigrqWM9Z4+XmBt3upmnbpA0i2tprN6Uzt+KeBVGvgIRfTp+U/LH10+cXSaBOGgbanwdrSYaXmPjPCOEyxGFCsldLiFHnFPJFjHW17xAK9W71CKD0fXmwfKxf5zvYwUNFU9RtGXEMAZy4C8o7cgiIcEC/3KAkKMvtwWGtpr0W3KFs4pOeBcIDOKIxg4QwV/05yWXmbs/fm8WYFC6h7BnVlaQk4Y2KMsKO5sXHuejuSfTZk5VM01FmlZgty4TNgKkP8d5nUZfz0AU//pfrK8oV4rOeJfmRQ/irBLu7qOsVl6fSXM3nWqnr9RbyYtHiizEBimxCUsKJwTrdfwjd9tcKBM0Ml4Lvzgag8Qyu+RK13XXZy6yCgdyfkvm++6q5sPdALmCYXaT2+HDCB4gYL7UZf/e1st0t2Uiv5IRxpCWgXW2PVUnBjYOd41A8U6vHuhiYfiNoMLKnGqMN2azIMkfIxSDymMMDkZrjpGCiansvtPtUg5cwV/px8nyIt+ud6k75Amg35s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Borislav,

Sorry for the late reply.
Please find my reply to Sashiko reported issues and
apologise that the replay is not in a patch friendly format.

1)
> diff --git a/drivers/ras/acpi_ras2.c b/drivers/ras/acpi_ras2.c
> new file mode 100644
> index 0000000000000..51adfcddfa99a
> --- /dev/null
> +++ b/drivers/ras/acpi_ras2.c
[ ... ]
> +static int ras2_update_patrol_scrub_params_cache(struct ras2_mem_ctx *ra=
s2_ctx)
> +{
[ ... ]
> + if  (ioread32(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING) {
> + ras2_ctx->od_scrub =3D true;
> + ras2_ctx->base =3D ioread64(&ps_sm->params.actl_addr_range[0]);
> + ras2_ctx->size =3D ioread64(&ps_sm->params.actl_addr_range[1]);
> + } else {
> + ras2_ctx->od_scrub =3D false;
> + }
> +
> + return 0;
> +}
Does this logic misidentify a pre-existing background scrub as a demand
scrub?
If the platform firmware has background scrubbing enabled prior to driver
initialization, ioread32() will read RAS2_PS_FLAG_SCRUB_RUNNING. Because
the driver's internal bg_scrub state is initialized to false, this assumes
the active scrub is a demand scrub and sets od_scrub =3D true.
Would this prevent the user from controlling hardware memory scrubbing via
sysfs, since writing to enable_background might return -EBUSY and
writing to enable_demand might return -EOPNOTSUPP?

Shiju:  This is not a valid comment.
Please find a description from the spec.ACPI spec 6.5 RAS2
Table 5.87: Parameter Block Structure for PATROL_SCRUB:
Flags (OUTPUT) : The platform returns this value in response to
GET_PATROL_PARAMETERS:
Bit [0]: Will be set if memory scrubber is already running for address
range specified in =E2=80=9CActual Address
Range=E2=80=9D.Bits [31:1]: Reserved, must be zero.

 ioread32(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING
 ACPI spec 6.5 RAS2 Table 5.87: Parameter Block Structure for PATROL_SCRUB
  Field: Flags (OUTPUT): bit[0] - returns status for demand scrub only,
  and thus this condition still be false for the demand scrub as well
even background
  scrub is enabled prior to driver initialization.

2)
> +static int ras2_hw_scrub_set_enabled_od(struct device *dev, void *drv_da=
ta, bool enable)
> +{
[ ... ]
> + /*
> + * The validity checks for the address range to scrub need to be updated
> + * with (base + size) > (mem_base + mem_size) check in the future once a
> + * proper method for determining the NUMA node memory range is available=
.
> + */
> + if (!ras2_ctx->size || ras2_ctx->base < ras2_ctx->mem_base) {
> + dev_err(dev, "%s: Invalid address range, base=3D0x%llx size=3D0x%llx\n"=
,
> + __func__, ras2_ctx->base, ras2_ctx->size);
> + ret =3D -ERANGE;
> + goto enable_bg_scrub;
> + }
Could this permit passing oversized physical memory requests to the ACPI
firmware?
The driver checks if the size is zero and if base < mem_base, but explicitl=
y
skips checking if the requested memory range exceeds the NUMA node
boundaries (base + size > mem_base + mem_size).
Since mem_base and mem_size are initialized in ras2_mem_drv_probe(), would
it be possible to add the boundary check here to prevent out-of-bounds
physical memory accesses?

Shiju: The suggested check for NUMA node upper boundaries is unable to be a=
dded
          at present because of the reason given in the comment added
         (proper method for determining the NUMA node memory range is
not available now).

3)
> + goto enable_bg_scrub;
> + }
> +
> + ras2_ctx->od_scrub =3D enable;
> +
> + /*
> + * May need to return the error code from below function call to the use=
r
> + * if the below function fail to update current scrub parameters even th=
e
> + * demand scrubbing has started successfully.
> + */
> + ras2_update_patrol_scrub_params_cache(ras2_ctx);
> +
> + if (ras2_ctx->reenable_bg_scrub && ras2_ctx->driver_active && !ras2_ctx=
->thread) {
Can this allow hardware state modification during driver teardown?
Sysfs attributes are unregistered during the devres phase, which executes
after the auxiliary driver's remove() callback completes. If a sysfs write
to enable_demand hits this path during teardown, the command is sent to the
firmware before checking driver_active.
If driver_active is false, it skips creating the monitor thread, leaving th=
e
hardware stranded in demand scrub mode.

Shiju: This is not true. Scrub sysfs attributes are attached with the
edac device and
          are added when the edac device is registered for acpi ras2
in edac_dev_register(),
          where the edac device is the child of this auxdev->dev. Thus
auxiliary driver's
          remove() callback would be called only after the
edac_dev_release(), and
           edac_dev_unreg() are called, where scrub sysfs attributes
are unregistered.
         Also both ras2_mem_drv_remove() and ras2_hw_scrub_set_enabled_od()
         are protected against race condition using pcc_lock.

4)
> + /*
> + * If kthread_run() is called before sending the command for demand scru=
bbing,
> + * the thread may determine that demand scrubbing is not running, attemp=
t to
> + * restart background scrubbing, and then exit. This can occur because t=
he
> + * thread function may start running before demand scrubbing starts.
> + */
> + ras2_ctx->thread =3D kthread_run(ras2_scrub_monitor_thread, ras2_ctx,
> + "ras2_scrub_nid%d", ras2_ctx->sys_comp_nid);
> + if (IS_ERR(ras2_ctx->thread)) {
> + ret =3D PTR_ERR(ras2_ctx->thread);
> + ras2_ctx->thread =3D NULL;
> + /*
> + * If kthread_run() fails and the demand scrubbing has started running,
> + * re-enabling background scrub will fail. Thus admin/firmware may need
> + * to re-enable background scrub after demand scrubbing has finished.
> + */
> + goto enable_bg_scrub;
> + }
Does this return an error to userspace despite a successful hardware state
change?
If kthread_run() fails due to memory pressure, the driver returns the
resulting PTR_ERR to userspace. However, the driver has already successfull=
y
sent the RAS2_START_PATROL_SCRUBBER command to the ACPI firmware.
The rollback attempt to re-enable background scrub via
__ras2_hw_scrub_set_enabled_bg() might silently fail with -EBUSY because th=
e
demand scrub is already running.

Shiju: In my opinion it is correct to return the error to the
user/admin instead of silent error,
          to indicate that the background scrub will not be enabled
automatically by the driver.
         This enables user/admin can check the status of the demand
scrub by reading
         the sysfs attribute 'enable_demand' periodically and
re-enable the background scrub
         when the demand scrub is finished.

5)
> +static void ras2_mem_drv_remove(struct auxiliary_device *auxdev)
> +{
> + struct ras2_mem_ctx *ras2_ctx =3D container_of(auxdev, struct ras2_mem_=
ctx, adev);
> +
> + if (!ras2_ctx)
> + return;
> +
> + mutex_lock(ras2_ctx->pcc_lock);
> + ras2_ctx->driver_active =3D false;
> + if (ras2_ctx->thread) {
> + /*
> + * Prevent the thread's `task_struct` from being freed if the
> + * thread function exits.
> + */
> + get_task_struct(ras2_ctx->thread);
> + mutex_unlock(ras2_ctx->pcc_lock);
> + kthread_stop_put(ras2_ctx->thread);
> + ras2_ctx->thread =3D NULL;
> + return;
> + }
> + mutex_unlock(ras2_ctx->pcc_lock);
> +}
Can this cause a use-after-free or Oops during driver removal?
In ras2_scrub_monitor_thread(), when the thread finishes, it sets
ras2_ctx->thread =3D NULL, unlocks pcc_lock, and gracefully exits:
ras2_scrub_monitor_thread()
...
if (ras2_ctx->driver_active)
ras2_ctx->thread =3D NULL;
mutex_unlock(ras2_ctx->pcc_lock);
return 0;
If ras2_mem_drv_remove() runs concurrently, it takes pcc_lock, sees
ras2_ctx->thread is NULL, and returns without calling kthread_stop() to wai=
t
for the thread to fully exit.
This would allow the module memory to be freed while the kthread is still
executing its epilogue, which could result in a page fault.

Shiju : Sashiko specified that the thread function gracefully exits.
Thus calling kthread_stop(), as it suggested, in a kernel thread that
has already
fully exited on its own, risks a use-after-free or invalid pointer
dereference, which
Sashiko likely to complain next.

Thanks,
Shiju

On Fri, Aug 7, 2026 at 7:00=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrote=
:
>
> On Sun, Jul 26, 2026 at 10:28:10PM +0100, shijujose2008@gmail.com wrote:
> > From: Shiju Jose <shijujose2008@gmail.com>
> >
> > Add support for ACPI RAS2 feature table (RAS2) defined in the
> > ACPI 6.5 specification, section 5.2.21 and RAS2 HW based memory
> > scrubbing feature.
> >
> > ACPI RAS2 patches were part of the EDAC series [1].
> >
> > The code is based on linux.git v7.2-rc2 [2].
>
> You're probably going to hate Sashiko by now but there's more issues agai=
nst
> patch 2:
>
> https://sashiko.dev/#/patchset/20260726212812.89266-1-shijujose2008%40gma=
il.com
>
> Please sanity-check them if they even make sense. If they don't, you can =
say
> why and we can ignore.
>
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

