Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0493A606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PJ/a2Jf6
Received: by kanga.kvack.org (Postfix)
	id ECF036B05B0; Sun, 15 Nov 2026 10:00:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7EE46B05B1; Sun, 15 Nov 2026 10:00:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D952F6B05B4; Sun, 15 Nov 2026 10:00:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B00A36B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:00:52 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CEFE40799
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:00:52 +0000 (UTC)
X-FDA: 85437665544.12.0D1C3AC
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3CBF020013
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:00:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="PJ/a2Jf6";
	spf=pass (imf03.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794754850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MVRNS3ac0YlanU0Fwb5KpLyyO9U1oXwO9vfFA3eak4=;
	b=CbpCnfL1RiLkQ76mp6tn7zkkMqaZogjQz984/X5iWfRmVDIGEGm2c/UGc+gi4HXGtDivcg
	4j9pbKaGY1cZwgBggGFJr1ZJlFdElyoOdaQgoZ+WTFd1cW9qaprBz+r6mhHgVcPZwLfVuI
	q/prTYJaQM8IEocm7F3PLiVOYj91n+o=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="PJ/a2Jf6";
	spf=pass (imf03.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794754850;
	b=ACLyzsqEs8xls8uFmhr6W/MmMvbD0+/i9hQXe8oglHBqu3a3NVl7vPrZHmSSi4OC2GBswg
	q7GplyniprXpAJ2P+N2Ml36pcJF+KsjQ8+gdE7NPO6GtKvbEDUqUxCQGGrl2Q6VWFxptRo
	KfYnQkOSWvoiKCzFjiTvIgQKc0UDVEQ=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c50cc7540b7so67032966b.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:00:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794754849; cv=none;
        d=google.com; s=arc-20260327;
        b=eNdfwAlGr9MRrbheoF31YKxM96WNB21c+INwPSLcRdG+FPE49XnJo6TeYVEGQaUTtm
         vp7x2oEG8P1aNgXBZ9XDO3lQVplvou6V3ykm20ToH/tUM3UVMNB+aAqy4sIShp7HCDJQ
         FSnUaGkEoPZHwfwryIBEaPIilQTXwy2/YP8yfZxIyoFOqE8XzG8YiKb3tk+70g3MkOV0
         2T4yWJIq+utN//IOYqAiBXNjy3C8p/3WxGaHtYnF6y6n0u+Q08cWxMjispisJ50JSNm0
         jvDYKya7sWTBWcMDh394ym6Aa/jHScYlaTaJwpwHEGu2SOiOJS08s2SeC1OlBTvpJUr1
         EVqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1MVRNS3ac0YlanU0Fwb5KpLyyO9U1oXwO9vfFA3eak4=;
        fh=3tpB3yPuZWh8Ie5IjEAWanoiXgAiNDh+M0AJXxK7Iyc=;
        b=bbDddKfnBwpWwkZbNsqtV2bS99tVzOfFSEAl1SrWP0R9t5kTgXKVPPA44wE9pvQa80
         dN4mMuvQ1tJekccw2d85pAbPVQ4nSvABCYwKraS0fiCpbtZx+ROfeSJkLNPBBjfmdyy1
         ijlnP1TkW/Rtva2TllCKGym4nOyla457JJRdAmzX2uXN5dk8KZHIWtsrA4OdITOFPkVl
         kpcF4MYt3KoPddpihbKCNC2z/bpWxf1XwDNHYLO9qKxEu3CiyJ5CFmZiH5/uOyM1UvR2
         REDhYlbTcX4ppMV/h4MXepmc+XFuxkphhlE4EqVtqionqsegv7PXEGwXQaJltJvG241k
         gDkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794754849; x=1795359649; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1MVRNS3ac0YlanU0Fwb5KpLyyO9U1oXwO9vfFA3eak4=;
        b=PJ/a2Jf6jp98YZOHpRJHL0z9zkn3xAgFTSBGbJl8EJjUQc+e1rqvDjXCekZQuh62Kp
         ZewuH+Cq/zFUPDk5Mzm7fDCR0EJxoTc7xcxPieuf0CWLHKnkdVG7Y0JKCn70zfG5CcPq
         N6Mpo94Atw6hw9hzx9moqXWJe3C0RkfSSowUIZWrOhjmoc3cXbL/FdaFEy02ORmxVC87
         cWQcFvBhQVMHuq4mb2Jf3cfrpBu+Xj93PFpvFuxwb9MjURXdIyHBoORv4830N5UudAwF
         syidHJL9cvRiNejuO2lF8l87JbRQ7stp0EMeTDxvXu+FiWbnRTOPFaIyAfb1NHFWEyhP
         bnVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794754849; x=1795359649;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1MVRNS3ac0YlanU0Fwb5KpLyyO9U1oXwO9vfFA3eak4=;
        b=2LMVPA6iVqA4AJ3tg3yER3p+bQXsSzrTZ8jF+T0/hZpOWykBW/hFe59YoSgSWYb0Dt
         x6yVXRsefjvcdbYn3MQdXJ54wlUrdWShPqSPcD9PQCruCKdojmZkHhfUQ8sqvbYbBBNy
         7GSFkjAw3sJMG+IFRMYDgpmuNcMYZI+vDFp/wBEJ5204dylIHwnX7RQJxGGDGCN3Abrp
         qvs1geDw3NeyXDFbVdBjoU4LdPTd7BeuqdJS4Fpr9izv0w+l96zdN+Zk/GUYa45NCQaB
         zv8QcQ5qHzp2kl0yTrbBwQViVFu7+WuthQYSMhRhn3bYW7x3izUE1EpLfX85YWVoqMlR
         SPPA==
X-Forwarded-Encrypted: i=1; AL+hErFC3syiaDPWatRtKrVuPWkdqu7Vn+OZnAGJ85gV1K66NxsuCiCL1jk7xDQA66qeHiA29sorx+OLqw==@kvack.org
X-Gm-Message-State: APuU4Z/itz9pEL89kpD2jXC5hWZBpuAwTORD/RTbcgX/d7oU+byzbVz3
	7xybwjkj7o1RjmuPgmvZP9AHsU6mIlxjNzMd4Lb5ixoZMlQ5WL1LNWm5xQNdRyupMJQFR4fKNQB
	jfZ/gf+8wWf7qDvXAww5rJRt/FSqdfgY=
X-Gm-Gg: AYBFou1YoJOmiQAwHdGHQ7hCK9jJf4nVYxLaRQq9NX+b2kiFPQMf5CLIWGyF4H1jVng
	jXG5nLtI0SUPEtP0fVetgB/L43ALw83vtnvD5FHL5pUyBBGFAeNgKTiq4f8mW0yQw6ddDtDYvI5
	X7z7Z2WNr0XnpMeNA26r0xKWKcUCZvD6jcqVUW51KjRk5M6syE76eS/Co3j+RUV6uHnov+wawiX
	O0D76b7R9rGACeEfer0KWKmIqeQ4D+HxirNAJJROXM4n8oe7cr77ynckzn2TlSKOETmVeDTG78B
	FcU1/qQYN7mt4gniJE21yrir9CQOSI0IwKyc4WliooNgTuS3lijiIYQeuozCnND/iqW7rG0h3/s
	7MEsRcWyQ1EHSMSovllB+IYUSRtw0lEevbgSdqXgxPXuCIodJdkX2pmUCancOIbHv1Di8MA==
X-Received: by 2002:a17:907:6d11:b0:c26:2a2:b91d with SMTP id
 a640c23a62f3a-c509612a23fmr694079266b.6.1794754848470; Sun, 15 Nov 2026
 07:00:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org> <20261115-work-ovl-d_real-v1-2-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-2-ca155efbcb2e@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 16:00:36 +0100
X-Gm-Features: AclHuK_wHYShIpzO3KRe2QttGftKj9EtJqTGjYXExDCpgXdtVHvMQ3jGuPVE7gY
Message-ID: <CAOQ4uxjoHbevvu8auB4m8AVcY9H6uHdDAP6mfi9OOMh+3775xA@mail.gmail.com>
Subject: Re: [PATCH 02/13] fs: add d_real_data_inode() and d_real_metadata_inode()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5fsrqcgxhjdzrh6spmqtre5ztoxm6gib
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3CBF020013
X-HE-Tag: 1794754850-481362
X-HE-Meta: U2FsdGVkX1/QwBLJK1Isf3N+PNLkV5LFF8JzRExYspqujTm+Ji03Wd0zYUHPVyuOa4wyVMJkuLE+/0ehZwzChDmFMXbbmjTVwGYRQpFkZPo2Aae73qpb+Z2z5Q54tr3ioUdkyYCOLtJ3LJNCxL6fVDmcVVbRxs6iCfwOQE2+fpLnWfEsqGBPveW0bh3z+JI/456DCJ8RZeXbCuKBnHWkycoeSuCmr5gKMOBJF91IzctbblntOTk0WN0VoYJLswUs2f+O8zp2gWTsptr4dePVQhUSD8Gb6AhxoV+FDrAH9k0FQQ+UxaV1S+0K1MNp5loACx7SLVgzuWnZtmxvIoPy5sYjS6fL2XeXkNklKg0dZbaLL0EQKY6tEuLtYJRNCp1VHB02a1CIcJrYfBY/cYLWF0dYwJQ3RQYOaQpb5lTPc9dlXjxueSMpYRn7PSjuohiL/n6TvL/D7evfGhIXVC0fVkpE0gL2JPWSaTIzb0KG0T25bZKMlctSJvBUkRDg4p1z4vQTb7+WqFmm9kItOBxWQsoHf3gxZhcjaG9GWezN9scqEtLHsfnv5QqdkGQl891M0gx3pPYe8eG+DO/J0K/eUaLn7PXty0aalFEQzH4JAGTEvfJ9JVMZ+lsy+yCAAAJp36/qlVwMsnCpQBwJVK3oA5ljaNJIGGyJ0gCpKLYEgIg5606FLMxmJ9BPnCzL48YGfaDj2nJpNusCEUiJXiFf5J0mZJUpEWJfsggsUD/9Ws8wEMab52AXdrkUNrLMnfqeHuJMA6gYwqcWLyqmABTf+iZJu4/E0wSKhGuqYVOqioIKXM4KmxXz20Ws62EuGgmxnkqV5cmxhs4G2JB8qbZX3Adbxw0ckkRwKHoLOFlzEF7ONdLQw0MQhTkX8zLVJSb+mjHbn5st3BiNNjeVJqrRBtYjRdgLud32m+etNThC8ewuifEHhukOkylV3wsg9aV/K1v+W32toFJrWa4lKYb
 vpYZtaRo
 93ZR03a0JSmJ6ZUr3KxEtO4eW2wveGSRkcZHx8n26cd5pss46BDN+P5fZDeEH3/iiAz+fSG8iQ/0lk2tHdPUolf8+KZPEyR9251LiIsUwmbPT+2bxEF4Vq4LGyohAxQE9bc1/Np+8f+2UP/X9FQsVg2OnjVB2unCEz3cBgnKlB+iIpONX9ubNZ7JxN/zaug0/JcqAhrIwS3ZN8aMSgHaoPki1UDjy7hSJcDWn97BwcHKuTPkxYZTTJNkHytp/7frd1GlBTy+GC2jO2wSAHcR9QQveRkKUrNMs0CZvXpSMcqIuO0qDKuF7yCC0l67tjbEcZhmDPh/FLK6mQXbPtkTjIM1sz0A7XxcoCdB5vHq17+7Vyn7hKpxCEgDFEUeZy7i+vDkrSCabHwg4IeTQmNKRpU+SDiCeQn455tiv4W0NPVlv81A6bj0Qk3JrLJnnh6KmeXd1UARbcw0mWdweOD3hFrWX9HLBT2rnjL4kQW9YPNaliXU4qJJnHrLWVw==
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
> Currently, d_real() can't fail. When overlayfs fails to look up the data
> of a metacopy file in a data-only layer it hands back the overlayfs
> dentry and callers silently work with the overlayfs inode. That's more
> problematic than current callers realize.
>
> For trace_uprobe and bpf's uprobe_multi it means uprobe_register() fails
> with an -EIO that has nothing to do with the actual problem. For IMA it
> means the stacked change detection is skipped and for IPE the file is
> evaluated against an inode that has none of the properties of the real
> file.
>
> Teach d_real() to fail and teach all callers to handle errors. This adds
> two helpers for the callers to switch over to:
>
> - d_real_data_inode() returns the inode hosting the data or an ERR_PTR()
>   if that can't be resolved.
>
> - d_real_metadata_inode() returns the inode hosting the metadata. It
>   never has to look anything up and so never fails (but no promises for
>   the future).

About those promises...

>
> d_real() can't fail yet so this is a pure preparation. d_real_inode()
> stays around until all callers are converted.
>
> No functional changes.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo=
91QjJHH9T_Yw@mail.gmail.com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  include/linux/dcache.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 84b0cfe4ed0e7..674bc50b81827 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -3,6 +3,7 @@
>  #define __LINUX_DCACHE_H
>
>  #include <linux/atomic.h>
> +#include <linux/err.h>
>  #include <linux/list.h>
>  #include <linux/math.h>
>  #include <linux/rculist.h>
> @@ -660,6 +661,49 @@ static inline struct inode *d_real_inode(const struc=
t dentry *dentry)
>         return d_inode(d_real((struct dentry *) dentry, D_REAL_DATA));
>  }
>
> +/**
> + * d_real_data_inode - Return the real inode hosting the data
> + * @dentry: The dentry to query
> + *
> + * If @dentry is a regular file on a union/overlay, then return the
> + * underlying, real inode that hosts its data. Otherwise return d_inode(=
).
> + *
> + * The union/overlay may have to look up the data first. This can sleep =
and it
> + * can fail, e.g., because the data is missing or because its verity dig=
est
> + * doesn't match.
> + *
> + * Return: The real inode hosting the data of @dentry, or an ERR_PTR() i=
f it
> + * can't be resolved.
> + */
> +static inline struct inode *d_real_data_inode(const struct dentry *dentr=
y)
> +{
> +       struct dentry *real;
> +
> +       /* This usage of d_real() results in const dentry */
> +       real =3D d_real((struct dentry *)dentry, D_REAL_DATA);
> +       if (IS_ERR(real))
> +               return ERR_CAST(real);
> +       return d_inode(real);
> +}
> +
> +/**
> + * d_real_metadata_inode - Return the real inode hosting the metadata
> + * @dentry: The dentry to query
> + *
> + * If @dentry is a regular file on a union/overlay, then return the
> + * underlying, real inode that hosts its metadata. Otherwise return d_in=
ode().
> + *
> + * Unlike d_real_data_inode() this never has to look anything up and so =
it
> + * never fails.
> + *
> + * Return: The real inode hosting the metadata of @dentry.
> + */
> +static inline struct inode *d_real_metadata_inode(const struct dentry *d=
entry)
> +{
> +       /* This usage of d_real() results in const dentry */
> +       return d_inode(d_real((struct dentry *)dentry, D_REAL_METADATA));
> +}
> +

Wondering out loud - since you needed to change IMA anyway and need
IMA patches reviews, do you think it is hard to also gracefully deal with e=
rrors
from d_real_metadata_inode() and not have to promise that it never fails?

This question is not intended to block your patches.
If there is a reason we should keep this promise for now,
I have no problem with it, so

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

