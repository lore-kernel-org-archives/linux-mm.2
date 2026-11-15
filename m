Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A82606A883
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nhhl9/VP
Received: by kanga.kvack.org (Postfix)
	id A07536B05B3; Sun, 15 Nov 2026 09:54:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF486B05CD; Sun, 15 Nov 2026 09:54:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8E56B05CE; Sun, 15 Nov 2026 09:54:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9E16B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:54:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B7F81C4124
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:54:42 +0000 (UTC)
X-FDA: 85437650004.22.BBCF3D5
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3118160002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:54:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="nhhl9/VP";
	spf=pass (imf08.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794754480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oqISismNDREzK3BapMQL3oVfFqMKLBzQ11G0pwa4rCw=;
	b=uiQyvu2CIFOZdX+gomRn6lBRqwS+hvvW5SkCAGfIm4JXPboe0yOH7q5ITWKkV0r8t4ywyS
	YZO03bohaHmosoqel8N29GnBtSGn1JZGLffUE3hZD5qH8jBgbSPShyxiGFwU9M5hUei1e7
	G9yunKWrrDdzd/sj3GFdVbVbVkQeei0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794754480;
	b=7I2TevhJvkpu4Ta4NVcr0RQWsxeR48efHqauqkEQiWUaSTDxOkKqdc0kBtYDOwIi6y8ok8
	i909u2/elQHROBW8VT7jsA4yKalJ5gyC+EOZwtN2B6B5/XH6U/Z2zxAstLkHDiOg10IBj2
	wrCMPpKdBacQapJXjgtKfvU0jMsrUP8=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="nhhl9/VP";
	spf=pass (imf08.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so4336896a12.2
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:54:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794754478; cv=none;
        d=google.com; s=arc-20260327;
        b=PLYIRZu3wWx+f2SuB7GMOmOWcJLipqeozri2LCFdRRXjcAO3AwK6gYJkmksdv+GInu
         fdFG4O+UhvaQafk96TILLG9RJ31NIBUwZgMSO1Yx3qrVM7gtnOYDFMNm4qvktCIRgLI+
         +RHZ074gZ9OKAlpnyzHJIjMrk474UnksOYqY48doj0QJogbE7RFbLFsfeykm6Q45M4cv
         MuxKXY1fEFBglTqsg/ZbDwPZidn0IpGA3rtQ6mBN3/y51eWxg+KizM1oHg0tnzPWe3/u
         Q6OEphHlArUDli6ORzYcvDYuJdmdnNtIg9OZ5KF2CwwsMSSfeYQ+HZOyMAFoIdCkJ76/
         lsew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oqISismNDREzK3BapMQL3oVfFqMKLBzQ11G0pwa4rCw=;
        fh=auHYCBlvLT+hGxKVK+xGhAdT0S+WM5mWgAuBbwZ4QVg=;
        b=WNn/I40BW2q3opxKn3IgPpKXHcaa+RfpgPbJ+ffhOdMqLsoiusP2+Iq3icA7R4wdJE
         AcPjOhMq4toso7k34v1fvOu1izgn+7T/wZTudhQRlxsG+dj5ddVxkcMKpJM0dmTZ1X7K
         TAoFColX3Q3m9poJ2cpZQXJpgoz+zI9pH3VjdAso8sog45oXA5API8ST3gDCSQ9WXo2c
         5exENhNH2LH/QPXCPmwFrXuoB8isqYwddwpJKKhoP6SSIuNLBEh8t6Ydt8VaYbIQqopA
         466RkWUzNjAcBBPSl39NBH142kQ67ibMTxabLBTkYzgApcihqumvIT6jj+Y9pV4WiVFJ
         EBtA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794754478; x=1795359278; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oqISismNDREzK3BapMQL3oVfFqMKLBzQ11G0pwa4rCw=;
        b=nhhl9/VPpCNXvSMl3aDz1/z9CMI2K0yQarXvjEKRRYRAQXHKh099YJFyooazDVFJDa
         o6qr5lmHhxFMuFcW4kaZ1PCFTEOfytAgMP6+qqDUoTkq5lMO+lp4ssRVcEFO+AnDecJg
         x6IzrXGDPJH0ivOtMBpns9mkEwR1TAxsjLIG8tvCPWSyZuTa4FI91zMX1hAw78kEYoa0
         vMc2Ft0XjTdRCcVlnlkUFU6fT1EMQ4jEOB5fxvSEDI7wx15qiipXkNiOgltkYbY8/FTA
         93Ang6cp+MQAwaXOXWHWeiUBLt0Fb2eS+V2pMtukaoXoqKkyoCC0UjyUZkcIPAgHNXN0
         6KUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794754478; x=1795359278;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oqISismNDREzK3BapMQL3oVfFqMKLBzQ11G0pwa4rCw=;
        b=ehsDfcN5to3Okmh9X6VIXwHIvDDNPWhRTw+26qsrJUBDTBNQi3uU0iGAC/YX+cMZIU
         0nxWVcD95hMQ/BcAstiD0feqmzFyD2SEEwTSUSCyaQXC2ZMDoeBzwKfVM7CvnA2n4j52
         929QR6D8XimC94z0xZccX0uQJ1pSAvcnIetqIilyyTG9/0CTsbazIau/Wq8mWa0/reUk
         h5HHrHieHX2tw5efvFxF3dM45MsVj8FwWacH15cP9Kg7t9EPUOeMzy8tKfsrAbZGovFV
         XY4iaI/uOY9Ib/y5QM8G3TXzySpf8eIJBbK1jWoujZtbK4LmFSp/26jEDdXaD8M6NEfU
         je6Q==
X-Forwarded-Encrypted: i=1; AL+hErF3Ze05f4/tgqLhOMxWs7AuzLeT70T4MK5JWuPmxINACiRz9MZkz5DnkXADXtvx5lwP5nXvWL155A==@kvack.org
X-Gm-Message-State: APuU4Z+Jm3d/S8d1S+sCkm8WTkIz91voIcWwSeNhsfepCyI6FBPHkk//
	rTTuFFrDcoXMKIW0fKLFRHiBXLlYM0URJ1bTDHFPnvzCdDJgWEuk76F7A6MYKggwcM2WvEijp1M
	PEb/eyb0X5yAXN9bePFKZ5jGbvUdVdb8=
X-Gm-Gg: AYBFou0fajXLVxPM6t0DiXRr7M6xDc0dyfGD0viFgTXUoosZR+XVkZ9mWVi26HX7srv
	XxMcOVfEU00BP92qRIoTDSPZR2SwwQWbPzuKrVD88glY0xDIjQGyKA37K1VOWGzqUG9rgajW90j
	GXb0eSWlEgs1d1vWbrIJOGCO/LZhuliowe2tx06l1+D9htaZr4p3oxA68ZJB4s9bxcbRO/Uiqfa
	jIvdDCu4kGU/Gl5xDnv0vzZspXHBAh9D+qCZ2hheR3V4ibg3K0oRB1wL1ix3yQD1cRgLGjToLM+
	Bs7liNuIC62cwym11OpVhIjfmpq5BCh4x3C5enBhKKZBTunFq1nsaGX+wl/dWmEHraq9SlNol6x
	vcnyr/mscL6DoB+lOqXgApKOscFOwfUUsB0Tf06mbNQMilYEfNkraTo9VyeRa2hwszXuf2g==
X-Received: by 2002:aa7:d1ca:0:b0:6b1:c2cd:db0c with SMTP id
 4fb4d7f45d1cf-6b7c0957c1emr4306146a12.10.1794754478075; Sun, 15 Nov 2026
 06:54:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org> <20261115-work-ovl-d_real-v1-1-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-1-ca155efbcb2e@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 15:54:26 +0100
X-Gm-Features: AclHuK8KXHVL-duO-F-YZ8XPwW63n9hxew9z3khJWwo4KtxA0bTnHEz-HW4OPxU
Message-ID: <CAOQ4uxhkqQE+ONrcgJNw2Jah59bKruxUAsLohTtKnsgTVQBw-A@mail.gmail.com>
Subject: Re: [PATCH 01/13] ovl: don't warn when the lazy lowerdata lookup
 fails in ovl_d_real()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6k5ikwczcwuf8fa5pw8edcd4kbmud3ni
X-Rspamd-Queue-Id: F3118160002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794754479-154938
X-HE-Meta: U2FsdGVkX18fsjxegQ2EKAD7z0ADnMGZm4tpLlZsPt2tqTPvNAN6Er2hzkyxdzWii9WidYTzRZwecsDFNCEA/64UhuLTnY9MtOvSEIMAuisK/utQt9zB2lsCY8kYrte+jpNcbs+dbuHL4SecRa/qxIcNBmuH0Z3E4EIEiFPHtdBEQ/YOiEmAfGyRnVgqcBiwOYyNw49ZpNAqReKcwi7CDSooGgiFW7SbiqqGB1CKXnyBvysDft1jv0JPHJVTxMhjzdwJCHEsMP2rkGAfGwM4r4kQvCIA9olS0mbym6Xx5lFTfCtXNdLlmuicwq4a/FAHBQ+DHOvahj71AxNXJWTn8M9+XtV6TwjnbWXTbPOAwE/3XjBKkbKL6Dh1Efira/JUVG3eeNVJjMAUc0bp7sFVSezEFZxrd3PCV3/3A4HrQlwTIfGHhbHWJDq9zsUZhX5zlM/ajn9KC7D7ovcQIkEUTRlM3NIypiiHuxGkXEUcezWOyb+b/E/rKoGbvlgtTP1Nkr9I03SpaE93Qp3K+EuNpFtbgZ4fBJFacaBlEhU2MxrgESTAzigFenQ0i8ZDLSCiKFjcJpAOhPwsy4AX4YjYP5pcySKbFsr0bjk0NROJdXvVVqxQKy3RxVI5rKvF+SjUIFDcI+LRpNw0HC2X12DLRw6oq59mBOBK+1q8I1K9bftL6kdQnUdIwLMRBWAQwX/3utaowS2HUOldJTg3oc6zTf/g5YXDabLcfjrIVv6zIgQvE2cSMxm3GQVo88DK6zqlipzoNoezhbxBbfHHGLbuqr/J40bmwVDyEcWUuv8aLcNCiPTOukGMhJOGmgFsTFr4+GUWWeg9f4mSbtGtVRsl1AygQSSaXDIpZpkr0/aiPoBmhkGExhbwybhQqbSDKyfI/TevWOlCOBhl+1nYJwlxvyoWqfr7VTdytd2UYGADstqeWTaOAWTeeF0S1nnU7uHmyBQZLoMDrjFbgYsa/Ar
 StLAMZKL
 JMEs4Ct8IHPufp4obLkvR0otx5gd4Hi/ugbC3QI0+tj2slq3dsHvFv3hTg+RssP0xLMnXXdgJ1iBLeifz35zMzd9/RwcC290imtRK/2tZDwZ7bncormmazd87ADcjGZVCiBEVAjK+cIybYN22ziV58arOHb6Jy8ZPv/ZdshaZ+rCTVWJmUE0M9j5Erb14wTD7USbpT7PcX7LIGbmPvW9ahxi9ebGCJXsLm9D9EoN9wngl30SWEXblZuFIzKtQyLTahhecycbEgBNXuzGC/h8ZL1BZJLLrrTXbLrIfFLVACsYsGYrZ3psGWbhm2NK91zloqwaefzw8xqlzwXGTrAkBIMOEDSlc4DXtvsHs5baq9U0EpryC9jyPAlb8iQ6MkjXunBoH6KTsh/mpi17rgXtyH/3qNuXgYdWjcS0OXMIocYmk6jHKw0PBD8H5wsJ9badL83DFsU8c5WCjlGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 3:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> ovl_d_real() looks up the data of a metacopy file in a data-only layer
> itself if nothing has done that yet. If that lookup fails it WARN()s and
> returns the overlayfs dentry.
>
> Commit 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in
> data-only layers") assumed that the file would be read before
> trace_uprobe places a uprobe on it so the data would be there already.
>
> But nothing actually guarantees that. trace_uprobe takes the path from
> kern_path() and calls d_real_inode() on it when the event is created and
> again when it is enabled. So a uprobe on a metacopy file whose redirect
> points at nothing warns twice:
>
>   ovl_d_real(/f, 0): real dentry not found
>   WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210, CPU#2: sh/27=
9
>   Call Trace:
>    <TASK>
>    __trace_uprobe_create+0x1869/0x25b0
>    trace_probe_create+0xcc/0xe0
>    dyn_event_create+0x46/0x70
>    create_or_delete_trace_uprobe+0x3c/0x70
>    trace_parse_run_command+0x1a6/0x320
>    vfs_write+0x1cd/0xfa0
>    ksys_write+0x116/0x250
>    do_syscall_64+0x10e/0x5e0
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    </TASK>
>
> bpf's uprobe_multi does the same.
>
> A failed lookup isn't a bug though. The data can be missing, its verity
> digest can be wrong or a signal can interrupt the wait for the inode
> lock. ovl_open() simply fails in that case and
> ovl_maybe_lookup_lowerdata() already warns ratelimited about failed
> lookups. So return the overlayfs dentry without warning. That's what the
> WARN() path returned anyway.
>
> Fixes: 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in data-onl=
y layers")
> Fixes: 184996e92e86 ("ovl: Validate verity xattr when resolving lowerdata=
")

Nit: 42dd69ae1af4 came first and opened the possibility of goto bug
and then 184996e92e86 came later and depends on 42dd69ae1af4.
I don't really see the benefit from stable POV to name the later as Fixes

> Cc: stable@vger.kernel.org # v6.5+
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/sashiko-outbox-214581@kernel.org
> Reported-by: Chris Down <chris@chrisdown.name>
> Closes: https://lore.kernel.org/all/20261114120557.4bc1eb6e57218cdc@chris=
down.name
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/super.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 08695a99f4f93..1985b553a47b7 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -58,15 +58,13 @@ static struct dentry *ovl_d_real(struct dentry *dentr=
y, enum d_real_type type)
>
>         /*
>          * Best effort lazy lookup of lowerdata for D_REAL_DATA case to r=
eturn
> -        * the real lowerdata dentry.  The only current caller of d_real(=
) with
> -        * D_REAL_DATA is d_real_inode() from trace_uprobe and this calle=
r is
> -        * likely going to be followed reading from the file, before plac=
ing
> -        * uprobes on offset within the file, so lowerdata should be avai=
lable
> -        * when setting the uprobe.
> +        * the real lowerdata dentry. Callers may ask for files that were=
 never
> +        * opened, e.g. for uprobes or O_PATH files, so the lookup can fa=
il
> +        * here. Return the overlayfs dentry then.
>          */
>         err =3D ovl_verify_lowerdata(dentry);
>         if (err)
> -               goto bug;
> +               return dentry;
>         lower =3D ovl_dentry_lowerdata(dentry);
>         if (!lower)
>                 goto bug;
>
> --
> 2.53.0
>

