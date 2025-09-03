Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4BC4CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 11:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ECE28E000C; Wed,  3 Sep 2025 07:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29DBF8E0001; Wed,  3 Sep 2025 07:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA7B8E000C; Wed,  3 Sep 2025 07:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5AD8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:36:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EAD98602E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:36:22 +0000 (UTC)
X-FDA: 83847735804.07.10782EB
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id C41731C0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:36:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0l01KSj1;
	spf=pass (imf21.hostedemail.com: domain of glider@google.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756899380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3IW4gClMpsxg8pegPHxJ+hydJ79H7ht+ce7OmUzWyQ=;
	b=hiCzfJJK2Dm+ubiOoy0aYZo43rLmyHHxWTT/x+VqdEij3GV9rlGQ8D1e0myjTreWpjHcR6
	qodYoiEOpqMtXdKW9JGe6/JXWtNB2UK7K586t/lj55Cx9VdBAilnvVkX3ENFY7sJL7IO7i
	qfN71fQ3YL4JC0p6IK//RHwvrqficE8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0l01KSj1;
	spf=pass (imf21.hostedemail.com: domain of glider@google.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756899380; a=rsa-sha256;
	cv=none;
	b=maIS/AIidmc5Xh25+NCY3zG/9SkYOJMcrIQwH/PxZwnJ4WNH4yMuherboiGVjfrkYoyFGX
	IgkS5s3+nQx0jf/5vjfGavN9L8zx+3vzOK4Xj+7UaYJ4ywshnmcgT/QhP0mE4hPbO10ZN6
	N2XqU8aW2/lzkHqzy17qdhwaDF0khAw=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-70dfa0a9701so67367236d6.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 04:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756899380; x=1757504180; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a3IW4gClMpsxg8pegPHxJ+hydJ79H7ht+ce7OmUzWyQ=;
        b=0l01KSj1Y4NVuqcriYCKG9F+uhvJIpsEsKcCcvmQoZQrVyktIiWGLrSNxihlykX553
         0vGvHenNhGbI1zLn1Ubu2wQ4xxOtcybBthltg9Njof0IZVJnSU8GjW317IRVRVI+odeT
         MzSP9/rPDgXGWvr/hpi1xY1S34RzgYobX6AT7qW6SAj/Pmo+O+/HimXCabAJJ5UjKL3p
         xCSKQmGcnT2HRYnzXYxuT2D4fu/VVUPCOMcTD9UTADwlSMZQ9HrCb8he7nXIxXusUpYk
         ifN/xIDAh+7YktAUwW8KkTdJKjfFsEmzW5k1C1GsYyHWA7TIU+F8noqf2tnCjWLAumDv
         JlzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756899380; x=1757504180;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a3IW4gClMpsxg8pegPHxJ+hydJ79H7ht+ce7OmUzWyQ=;
        b=Q7s1h9gZ7s9B0pBpPDe6z8LkCrco8Nj3F5F/4M15639n20zmtLzWjWnJbjFZbod4dW
         5Zl5if0RlKuaPZFKJ/DWqizhe7hb3rvUllWhaQGoHs3t7H8QSAEI46zC4HLSObNeqso5
         CV0d0BIxDJnpBCGvEcp51eA21ifwB3Xo9ajxhVts5A4uDuBmDAu+39nH+O5hduDkkMLY
         omhfpTO6eOx798YyIkPUuC3HBQ/LObTS11KVQijko2rgZ1TyOcbCwNvbtnqAeeSOHX63
         LHam4vcze0m5Fjxz+1+yONMXtqjjEfiJuVNDv67XmhkyuZaxKgnRipoddhtew6QVAscV
         uoyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTyFgYAmYOGJhWqSVegwSM3gSwiClchWgoWtWxLsqIJRFw4gAn3+aXiSD+IhR3oTwWQPQ/WVyt/g==@kvack.org
X-Gm-Message-State: AOJu0Yw9fEKbrJUQGk1TpCXP6VlZ0ja7j2JGYyY0eionDkBjxjCXVVjr
	35P/8foZ+xRtZ/Ukn58bxhrkmo33zK2dFVBj46zL/mxNnyOynFYcQANEROpIy43MKdl2OYmNB5r
	KY5cjrDCOWW8ytmStvTGrJYjEg+yOFiKiukMoimnc
X-Gm-Gg: ASbGncsgYp6ipAlRVgXBtrlHhw4KzatXOCnNysenhUrO7DR+0qsIDq0z/hkNnsoUAqR
	sER61Orp1oqZGTcNAUVNf4rhunmEmZKb/3FMW39+6ceZa7L5K0xeDnfuvhG+Du23SfPRFEsvjWL
	gjGvxxhGkO8nUduQ3BUG6b097T1F3W22Y4Q+N4MMgVNVVwFtEMxr7+tiM5SugbIcBtfT852wZxQ
	UzWqvuNZxaUaQx7lr+flnXILD2yo+tYnIa7/m+EzqU=
X-Google-Smtp-Source: AGHT+IHt5Uf7f9hHKKGO4y+S7XWf9ByCdyBez8I/gMbmDbS05z3pOWgerpBal3i6mcnzy0T4lRXiKY79hwA2pscstuA=
X-Received: by 2002:ad4:5aaf:0:b0:725:1fb:a6b6 with SMTP id
 6a1803df08f44-72501fbac03mr16948666d6.31.1756899379536; Wed, 03 Sep 2025
 04:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-3-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-3-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 3 Sep 2025 13:35:41 +0200
X-Gm-Features: Ac12FXyA87fTSQv-blZ3tbQBrKQAAZ9Bwbod18tXQa26iNm899ybg0GqU8LYCbA
Message-ID: <CAG_fn=U+xi3zjr+g+PaT_41JHSca1W6J72xd5=c0dVrSy75XpA@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 2/7] kfuzztest: add user-facing API and data structures
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: y8cyhx3dag9wmqqr5d6hh4ebcn19m6m1
X-Rspam-User: 
X-Rspamd-Queue-Id: C41731C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756899380-19983
X-HE-Meta: U2FsdGVkX18an21zE9sqQmDDe+Q1N0SrN8irIB8+oIhal9gdE3NjQMivlm/OeREc4MCsOwD3fGk5olgbocC9G2INRhuZo2vMyirh0VibrUrNiX+znDqCO4Yx9UveN29WGUYCXxVoMe8pt63LjfPWMyL0R2Mh5NGBJjgH95eNq4GBGBhDgSKmkKE8PFht2kHhd9jtS04iwhEcTFSf10S0w7NAdrDazhrhuV0KhNSrBgpR7bGVMEBqxVhUMZdhZ63r/MIM3SVQgWrfsW+2pgqmL5+YbVbu1PofNzlpoaXEma/eSrjZbWS8wvpf6mUgrREBQ178amKkMhX3DBd3w81TdbDMZvwOZs/l8WNXwfme4c4+pdhjDxO/QKe+3eFEOO1ZC8BPfmybwWIIb8U9PyKygAT8YC9AEcBdeOWMlVgGJhsSnPUAzjI4kVh8O/xa5ZtuoaP6KdW9B6QnQKMaPZ98O5vM8DUy15qCjnf8RjE9OA8wSmUE1jXiFStbDeO7K4BPe03kZH/6GMNOpVvJ7GFYVp1TYshByimyW2Fug8THoCQsJMohM0aP3UciTl/HUyUcb0LkyGTVkqkKiZO5yRxLFcF6RvbEoo4jb+DVi9UCO42jWUwr+m3L2IquVq7eMIEsen2Hs8js/w3vxwAgy//1T7T5eBmwYQBno1+7+mTASYm5uHZSSdwzDdwPLlK0QAvIcf966iopveFuLkr8G58otFuUMTCUQ0BV+x/epFPgdKgn45MoCTge0TAKogs0exTad/yaREzbNZafWnSym0HiHfCC6GX00JHY3BArWvpWM0wS2+E0mMMjjdtLPRjihuLEzDceHqZqMMWeNWYa8AwHkwc0qyWmT8GaWhwR8dCYecHFIKR8W018aGNbqfUn6jcr1k+kWVcdHetSnsbZmsL4zMG96mfh19jujxfJRfQ3tsLquC0LDpp0ix4a2zItShY71OP0XtTRft9OEBAYuqh
 RLU3mQV/
 eGjAVXOjvTIFI3HgHTX0H5qYf+mBg8p5z9Dn1CejLn0B4pMEvUmEUfm0J7Zo09QuHake9RILjoMyfPRU81pfRvmbP792v9+jbSm2jq2bkyj9TA0y/veyVnpoUEnwFu/qaPEqt+2moNTqGB9VTtSDtmKPg6v7d+uhnAuvuRvmMZFhM5ju8GpkVU/K2cOE0RzIgW0h7CetdtuQhmuA5H+NX1PMHPGqunNonv9qreMV0Ntmh00d362OBB1mYP2eJP5bz3DIzGSPK84i0i6o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +       static ssize_t kfuzztest_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len, \
> +                                                     loff_t *off)                                           \
> +       {                                                                                                    \
> +               test_arg_type *arg;                                                                          \
> +               void *buffer;                                                                                \
> +               int ret;                                                                                     \
> +                                                                                                             \
> +               buffer = kmalloc(len, GFP_KERNEL);                                                           \
> +               if (!buffer)                                                                                 \
> +                       return -ENOMEM;                                                                      \
> +               ret = simple_write_to_buffer(buffer, len, off, buf, len);                                    \
> +               if (ret < 0)                                                                                 \
> +                       goto out;                                                                            \
> +               ret = kfuzztest_parse_and_relocate(buffer, len, (void **)&arg);                              \
> +               if (ret < 0)                                                                                 \
> +                       goto out;                                                                            \
> +               kfuzztest_logic_##test_name(arg);                                                            \
> +               ret = len;                                                                                   \
> +out:                                                                                                         \
> +               kfree(buffer);                                                                               \
> +               return ret;                                                                                  \
> +       }                                                                                                    \
> +       static void kfuzztest_logic_##test_name(test_arg_type *arg)

simple_write_to_buffer() may write less than len bytes if it hits a
protected page.
You should check that `ret == len` and return -EFAULT if they differ.

