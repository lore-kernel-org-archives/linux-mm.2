Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B2360A2623
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=t5ezB8QD
Received: by kanga.kvack.org (Postfix)
	id 86ED06B05B1; Tue, 17 Nov 2026 03:28:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8457E6B05B3; Tue, 17 Nov 2026 03:28:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7366E6B05BA; Tue, 17 Nov 2026 03:28:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9006B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:28:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70E5AA7D83
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:28:31 +0000 (UTC)
X-FDA: 85443934422.10.E4BBC3D
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 90F791C0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:28:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=t5ezB8QD;
	spf=pass (imf20.hostedemail.com: domain of alex@amutable.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
	b=Bzgz+3FbLEivGapHjaKVJMrLw08wnw57fZ2MXweXvioTms3022BwDmtJleWsfPFunndMNG
	X5V5E7z/aGd39Z4LfJHBKX8Q+nFDrg99v3ktycD7l8n0eC+P1CHnk52J8Pka77BnT4ZHux
	FLpYeTtS5KafJPxyhluPBgrqfn5Kd3g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904109;
	b=gfZCX9y06mY7mSzEViKmCR1ZM4Fgv30oXX9hnaW1jadJfq7C7mwljG/BT2yPLJ3vM9qEUV
	+x4R+kldiq5KOgDzP4i1Y2w9UkjWncr+RCt1wwBMKNuqOpSBT1V9c21RU2rZUY+ztEx0V/
	6Dygjw7S0qlVPiKuyOUAaBRnEP6j0tk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=t5ezB8QD;
	spf=pass (imf20.hostedemail.com: domain of alex@amutable.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso28247925e9.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904108; x=1795508908; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
        b=t5ezB8QDfWOjKO/1iOcM8wb/k//yqt+XqZqZ2lhqlj9T1gGLqWbK/UKk6gpDigxNmA
         6TLYzab6ynKGSr08LNOwutyalf02UeKWxb0/md9FtRqGC3+OnuTkQKbteCI2dOi3kmr2
         dFVTDJtsIZJL+1a+4YmYPxXooVZmyNoikhCi+zDtQZZpg5s0V4hk9mnPjqKWU6Seb28n
         dARcgehHC3J1LzRMtb81ndy/l8FoJia6xRl7cibBmIofer7iZouIJzXHGFSkn3pLaAKi
         iAijFl8v5w+qfK0dTU5oIiQxUm8VXEV9swtcJuz30Dglqqck7tqV+qDo2GxlP+mvdu+J
         utFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904108; x=1795508908;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
        b=ubGQ8KDJBRsFCT3+Km8EYK/teB9bHCqKGboyvVBWt8ItDmSwx9YZkxmGyMEZXm0AlU
         fJfqNpoxeLyf/GR+9ZO8AcWespXPWkXy7DS4Yf4h38Skq3HTJns2wqptsWKBLZcHpNU1
         ZGvjcn87P/c5ZAKtgzSEwtlBm1vvripCVq3LI7g2U+K60ZwaQfJ++M1rP+Yvy3QwWkhQ
         rIV97YP/L/kOd8NvyABaJoIjrYTIp8yJkgOhSE+PnQwzye8jHMV1QeY94PJjOgheAnx1
         5YHoClqSSJL46u7wIQkrvPKGwuqruAUCIX9lYWQBAD1mS51OxCQilWkNI3OeA0rhWWgN
         Xoog==
X-Forwarded-Encrypted: i=1; AL+hErG+UyNXsxaakSBhD3I203JlZ1ap9Xw3hSJPa8OSdSUiA3oqtrWcYr7hTHlWl0lu35+ycuXWej11Vw==@kvack.org
X-Gm-Message-State: APuU4Z8vjD7v75ferw5O0JMXSlRzOfSL+HEJe7XxKRAJQc+fVXVCyuHh
	VxgyAgAPEACk90QFarlFcJd9tOdf5mfPLsv17Hjntqeu+7bVLmidv63SPmHgscsVLKH7
X-Gm-Gg: AYBFou1smA2HX80JvSDmzpcED6sH8cofpX2RIm0VBNER550uRJmkAzV06R6XKowTPh5
	gbDV79DmdyXWZpeiBzNFGD5GdES8VABVQdyD8oIeoU5ZkqNAMsChmJI3Nro0B7uf29l6gRQrrSj
	LmD69C7hLu3xVmI3jVFNCiyPqrxdmsox8dmI1xb+T7qXQe2Y5pgkZJYIz7V6g49iins+w8QL3w7
	ZNuiALfgrEGqvDoEZpYrKvQwoSRTxhLdkzY13N3OcHEJM6CydioHVrOaiq56pJxLyrWFoFIgY0t
	ztlZN7jSQyAUWIE7gB4idhNP3JBRpdDn/gkkDHF732YnBsH4vMMg9wbPcPV/6s0CSVqMoh1xWMs
	pzY2dF6Ur28B2IJ6CIGo4VKNFHUTJsiGqOC9JN1uHxvfRsPNTSqcwsQqLhgjeTWDELmjp0OeXLt
	lLkKpv7IATLvg1IatTB9wcWQnlVdoALBerOfHG9J4CgfStbO4nm8HD4W8YZHr+j5dU++XyO/EnO
	6bzNH9w1DqoqTiKhEv+tuDR1nNIv2Z8BhZRDMVi5NfgP8Obhnn/3PcZPksioCTTcyAACWiEwQXO
	Ym1Uv6gdC84gRhVUnnYEIoOA/ROMQHXfeVyWcVO1QiDUr9BKG3ESSwzjHZmwsmvCSyI5mbbx4U0
	GkP7Yqw0rxjbGML5ewjtrg6zXGSMMN9IuQBOoR9oF9VXyeq9sp4fXIrbb
X-Received: by 2002:a05:600c:6286:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4bb55a5d634mr255399085e9.5.1794904108278;
        Tue, 17 Nov 2026 00:28:28 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78422d2dsm75197335e9.10.2026.11.17.00.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:28:27 -0800 (PST)
Message-ID: <afc070a816e3ae5eb3c9e2d62d4f25c59ee61df2.camel@amutable.com>
Subject: Re: [PATCH RFC v3 26/44] xenfs: use fc_init_pseudo()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:28:26 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-26-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-26-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90F791C0004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: gcjcc6xeaj6djmh3cud4puncp6j1gtba
X-HE-Tag: 1794904109-121247
X-HE-Meta: U2FsdGVkX1/8r5akwtJwQSxidvrbDlpSKec/0rhYZXeKjqGgL9+VNYUV/IBvxCCo1tX/9OhNjxzKvEniR5A83xT9+j5qLuiv9453SZMtaNeIvaScVPlMV1CRzfbZcHe6t7BqZUg5+PJfq8LBTin8fCuk+e9AaGL7UM2nhYOL7bJAqDB4rH8LQ+prx1BkTow6ryPBO8BtpVnOcyCNfsfRzI57c+x4Gu5wmDXL92BVMWmMUejIqrVpGxj+S8xBEMBiGDTVlT/MpjdnPqgOKuREQCetBb27iDuep2uPEi9Db4KNSPz/ZKiCfLWCyxdtJ6uhoCOtfA+IUhqrdZwzkejoC64eK0QeRMFLkkUEKvPDUspjr3dzjkY3BaDDGuqtB8JNSKvMExsI+xhGv8PJd07rLOugDLZXRVleaiRm9hidq18cZ19K8v04hcvsNGvPEjjiKkZkRQETMwWD0VGpEB7n9kRNwtok98q6/osDaAv2fF5HjduwZF9JZdEV9wcbwocqN2ef5og+tmjRkhB+EJNeKbhf7k9aTfXg5R3xsttJgvENiG3AJi8CUHbPWdFkjOuuiDXIwK9fqfuuDwlV9vag6TmQzVn9Ci8D5xDne1DAYBf2ktFPTDvNk4ZUrFH9wpdzfFxOj5KZQqz8HIdfDSP0dyrxIqHyrJuNuTbWmyEq0cd4yoBGROmgIddWO3L8hn7n+aFQm7vnCbqD0ZrfMH3Oer2mUTfo8MxL8Gz8QWlCW/riN/qlLc20Mzgg6p+snSMrGZ1XILUhoBlR413zB7YncxXGDDwgIuQiZC9ZTSShzaUNapkpw48C2SfMi+yG9rjcunDFQ7GzM+3KHO5uSPN0tED9SU6lGRusw/jjboP+m5ags70tOfsQRDaTu63MSK5OtGLb9y05JzU9aWH3UfzwiqiyBLPYjUr8IXt9bH1bUfHWeRhqHFqYxXN4A0zK3P6Qt9DMZSO1HSkZZPNo/Ui
 HbcaS0M7
 4mcJCc4tUsYfSe7Prli4LAerXyJjQIyU1GpPQ+5W/scS2AZVP01cJK9VaCP0YpdJERNKxR8wE6disz/0MOPMt/Gdpr15ZwCxgKu4LO5M1zG+2xVOPDSID0BLE7QR8BlXk5xvNXOCj6433RtDeUQm5lBKAhwa7lwXInRNliUkDyjLslWDLrr9QaseC8VqktJfhv7g2Q34HQWVdf8WnF5C+HO/91epingUqU3PGHG4vd18nK0EnTjTxyQx4OisXjNCf1fvsVis3lh+RqIk24GElHMFF+EwaOaYnzZMnkXuePXCKcf1sc1sDEn2dtTlHWb/SA4cI78jzDx0/rwZa0lmmGPdgwXAHjeryiDjvO4vL/dR2uxVf39FnL2Q+M5EVrS+YUVhyYcp/+hAVP14BRpQTosDLRnonshK0T/Pujfp9H3o1w7q6KymdHkROLr/dO8Q1XvcIYpmb1ZC1W1vPI5RGL99rPNMLwTnbladw7NE+rogg8mDLWGUGlq5yUMtOLVCLGo4AwDPhIhs6atkCSFxpvdAyIrOK1Kf/5eOO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> Initialize xenfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. xenfs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. xenfs maps the xenstore
> page and guest memory through privcmd, both data.
>=20
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/xen/xenfs/super.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
> index 37ea7c5c03469..aba7d038ed735 100644
> --- a/drivers/xen/xenfs/super.c
> +++ b/drivers/xen/xenfs/super.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0
> =C2=A0#include <xen/xen.h>
> @@ -80,6 +81,7 @@ static const struct fs_context_operations
> xenfs_context_ops =3D {
> =C2=A0
> =C2=A0static int xenfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &xenfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

