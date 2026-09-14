Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65082C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 23:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7486B0088; Mon, 14 Sep 2026 19:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258A56B008C; Mon, 14 Sep 2026 19:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126476B0092; Mon, 14 Sep 2026 19:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D73A46B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:17:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 678CBA4D86
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:17:18 +0000 (UTC)
X-FDA: 85213930956.07.217C617
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5A34E40002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:17:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b="tU/glIbu";
	spf=pass (imf27.hostedemail.com: domain of emil@etsalapatis.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789427836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPKM73fBOFsSjy59aqqxc7UWTKxXfj0ZC9NrA+w1XGc=;
	b=D8Ruvqiv4wA22+PGVpqxqdS3x7A1uu9Is2ZCx5Zpf5aHH/C8YSUj3MlEwsX7JnclhR1zFA
	LaXiI8c5cUKFHb+ffVMoH+WN7ZLig0+p/LD9Obg0sISO73p2HxCB6Xk3FuTqdfO9bvVqE6
	juxiPO1/G3Y0qZa/EDk9Lsv3u78te5U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789427836;
	b=XEzsIGUgKUrSl9G2WWfaXGKytLtacvLlyI0SNSbGdXOJvgvYZjEYLrg1PWrsg1ZlmtHgUB
	lDIMmfYd6ai+nfKIRsMX1iYP+3MyH1t4aGwmr17SoOj82XipZP/wuVtEnH+NrlsE1xP16E
	3izXDbCaGVj9IeVBEVYlrM6owvhQA6A=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b="tU/glIbu";
	spf=pass (imf27.hostedemail.com: domain of emil@etsalapatis.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-67124ad72e4so3938776d50.3
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:17:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789427835; cv=none;
        d=google.com; s=arc-20260327;
        b=fCi081YONBWfWQiFDpU4Ys9rakESLY12RSPWC9G7nevNbBLItGzJuTO/TTX4zDXVZh
         hHR13pfVafWM+KllQGwJiEvG+FTh1Tm+NmQW6uRqX/ec8i8InwQdYwoxBguq1kjcl5Zj
         0vgueC3aEGcZJt+CTsmvByhD8GbiAttikokfO609EcQftHsQIHVg+rTRtCzPv6D5cpKZ
         GDNnXtBWPShXANQGE6OMa9WrbVR8gHTPf40O8CEdoCacGb13AtEBNmfUp08zfVLf8oxd
         fiOuAJNnqhYEoQhgAwKvpEvcl/y/1oCfznam99LhqtWV8RRMw6+D0Dn307EDJzAvP/e8
         jQWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rPKM73fBOFsSjy59aqqxc7UWTKxXfj0ZC9NrA+w1XGc=;
        fh=WlWCJ4YjTHhZtU89c4Ibkcn+afloQ6pgCjC4CgSPlek=;
        b=M1BhkIGpABP7PJ/2rnE0icFRDyANIpffZRozKEwN9dwAfYIaBjwqRNsv3hPekoqSNZ
         EBhN4L99x0HYr8KxIc7W4BmaYyEqjyG2MVgVuRkVfvKBjuz+Hu0RkvtDBCpYkfH4nLjm
         xHa4Hcjn6O94jw9fjJ3O+4XHBpI3bgznSJTb3MxBNj82ayDavodbrqqf3DjU1dkdPvr2
         FUFV+pxOSuXnQ7w7Gpys3bh0DLQ7YxeDn0Qlf4yfIlfh8jlvcgOviax94YMWtMQwyw+F
         ydieVZfuYXpWh/BPy6v09GyhUjlouHGttxG/L5XJ7Pn1rO14amJq8Ns8SAMlE9hMOHuv
         R4qA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1789427835; x=1790032635; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rPKM73fBOFsSjy59aqqxc7UWTKxXfj0ZC9NrA+w1XGc=;
        b=tU/glIbuUEK0B8qByRVUgwC2K2sIbZcPcCE1WC5lnF0iGqb59//a6LG+nZszSgxc9+
         byVwPxwQDxS8cDaV7/m4lXKaLZ3t+TzT+ksLwFFMgvG8fWaytXs+NIVoI9jYnMM4goof
         LCA6ROJqhE9ZWQ/Gak7gM0XGoRJPdfkfV9pqngEiNoWApJJ3OYP0u5+pJMwqX+9aSdfK
         qraXl7dwwSJWlDEMM9lG4u3ItIvAfR7PJfnzVZPfYdi7sUWiA/++HzJ0ylVh2wE1uzjJ
         frwGdO/Jdo+t2hG+jSJuPLm+J337LKkDeskNo9mPk4ARwUN/zPomT4x/DSiWsL3CkDYX
         CdOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789427835; x=1790032635;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rPKM73fBOFsSjy59aqqxc7UWTKxXfj0ZC9NrA+w1XGc=;
        b=HAGvc1sKQLtNPkkdmmA8Ta0/xVwm1V6ZXSuxXFydJ8RUjBRi2ZYAgH8BX9sFXL6MhQ
         g2CMxAUjzpGMIxFA3NqiKBH5NQldS1W4LeOiB6xB2WwgvyABCaDwlIc0KBBnxS2td+0H
         A9IFge3JKLF6WYH4S9ZBV1gwv2L05lQhtW6m2IQ9YxPYjZlq9aadRSNF69Juge4MCrWZ
         1aEfq7eCwKzuzAn2dTLESrRKZ6CP3B4nnoHgz73DRqWw2AEC0QDVD9h0yYBIA898Nx79
         j5XrXCB8SlynAh0c0/iJtMTho5dAzIcBIbj8QnGdS16fTuCe8jth5mKo749Fanj6N80/
         av+A==
X-Forwarded-Encrypted: i=1; AKwUvBxwJY1EN4YexNprzMiJ8ubETTtEql5OnN4Vc4W2An6/H2AY0lejxMv+rsmFcsyFPRPoKDBiR9T+8g==@kvack.org
X-Gm-Message-State: AFuF++nzT2151A1sNqVrwOM1t9iOPwB8NW516bta2zoiBG3GaYi4BQfI
	wcNNi2Ydrh/R28+irGwiFBIfKMKt2/DUyXWENGF3EG/l95T0JnMJwso7Od+m3f7O2+uAbLtOyMW
	YjKcZaYBd/VpEqh1ZI0SxUGevezFM0y9eTIScj7fvqQ==
X-Gm-Gg: AYBFou1bwyV0b9r/Og3A/a4EcOI0bzhZhxrrDwQQ7uVkJfndo9GfBw45ZkZM4tsV1EE
	L5GShzkKz3HMsKF8XYEj5ozQK499pG6nH3mcpeWMjcqmH4P1iaI3RJGWvWqGKNm+qucCXp+U8UU
	aWGUgSKHLbn+nrtXjXLft3m5ZbdF6fXH4ceearO831Jd/y+7vt6Ds9O/AqyyZNcfYTBLbibjxzJ
	oANyk4NgdjpQsAyj6BfPs0hOgKqMmWcotFn4Vox+/kvGRRPW3jd4xhnaj+Pr8i1mUmq1ltMbjqy
	rdZe7Jt/Ym03bIiFxqwIU562mi1RmoqetB1/5n6RYQcP91f/IHU1SDU=
X-Received: by 2002:a05:690e:d0a:b0:671:2382:d57b with SMTP id
 956f58d0204a3-6714e00a7efmr1347187d50.44.1789427834988; Mon, 14 Sep 2026
 16:17:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-14-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-14-7d9781ed5361@kernel.org>
From: Emil Tsalapatis <linux-lists@etsalapatis.com>
Date: Mon, 14 Sep 2026 23:17:04 +0000
X-Gm-Features: AcwNN1UnQs5y9ap_T4Dsaa6llmYZN4_govFYy7UyV78s5E1rt3VhMagl8qfkC_o
Message-ID: <CABFh=a7Sa0zMKssts1TVZ+u_x3roWcYVSmJF34K-W++oHEsbEA@mail.gmail.com>
Subject: Re: [PATCH v2 14/40] bpf: arena: mark arena_map_mmap() mappings VM_MIXEDMAP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Paul Moore <paul@paul-moore.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-arch@vger.kernel.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: pqzj5tnkox5px59cwi11rp4s3txutyou
X-Rspamd-Queue-Id: 5A34E40002
X-HE-Tag: 1789427836-421518
X-HE-Meta: U2FsdGVkX18ktuul7Kdvsv1r0PX7q68lQZOZU1ahYoNuv3u2AgFUQudjHKMC/ii25E02XfLQLuU3OkCzCu+cCYqcnYdEro9pHdIinwgSMMpFDl2hlDxri+E7HRWBi6PVcwjalqUD6PzDBaRbtkyL8PIjPYAmwT4eUHZVnfw4dBlRsQaaECUFc+noW5WNRBW7etFEyjzHnp5FTgikxQsXDrJV+2u075vznQP1POsJaQp6XSCwvlqF4L/dLxgTWxaPC7rddZV1psgaKAJ73RUWo1DRMEqg0rrE8mJinvB594nNm2cpP1PoP9NX95FeIfgWpbwqZ2QyWGXCDb0Jf/9EC4BYC2sCaFYXqIC797H+Jwu2pa8BbSlEn0/zDM2awQdyW561uFtmfJjUjIg33Q6uoqY7NkN4wqfz/6gxId8M1Tx+GKPlYNnj8eX2Uj6rXB+PogIyu/7Z76hVpk4/H9OV/wQeXHx6/mgS5Tc1Anuzhg281Hj/Rf5zzvhDWSx5QEisUUZ46Jk3txnf/0wZVIykvTH9JsH9GcVhfqhCurlre13anX9RW/CrVarQtNfqn2+rCjKKkA8YTJI9rILomBgQ0fDFmUB3lUY6mH6fJxkEd9ByrYwomCX6H6kDqaMmiWLd0QZlfLmnfgXvsZSEd9AdbshiL4mGein+vkDpxpyuzs2aG+UlcOAiXnVICo1jKdGcSOb9bUx1YfosWOOaLd3gHS55fkL0WzXjjJbGJfB/vLLg+LSa2dD56IiBu00JoivxdLx03BYqezo7f5PntDDqdlexUTQ9GgQKuxSgcmzgpAzbDU4IvxQGZo/S7qZBeFV0baMeY6KjebWfbp2zzaGYbqvHBQnEl6+ESc6VW4v2tFf48mmeFB5C4cXyHXUoSVd7zV4QAe6sY4wIgW9S7I6yJ3RgiifZQr3nM07dEO8FkLpl2MbkILV9DgWvuTB8w2IPuZgJyUQynyqFAba/V81
 1D3y4sVq
 25XPGZaaUVxq8l/0oXCNDrCcU9auCwM0iJdcx5lQ13YBekBAXxkZV9LRxjWIpluHJU4AfmKss8k26l98serUCS73KOxaj1oayPx6dqa7qjPzWTOXYjtapfE1j5aPK3M0tuC7Nu3yVMMxzP+0Xum+7VnjiYEBOqyoZ1C4QmE0WvussgUbc1zhY28iAazM+BlOq3BxG/S2SZVR6NBC5pQN9WhQx4IVT6msR4WxPhYiTI8WCIVDADwYQUQEnv6Ws586QCxstsLVqY3bxQDsPQRgw4s+IB1+sTR3A7XtXyJZjUAQ3Ytbn/rtpyXuoqcrKDjJtheU9KqyhDOclabIUulVVUTdz4GU7XVUCk77q+9gKOX9imMbXr2STiiXEmxeYVKF8zui1RhCKhEcaVJ3DrvU4l172GNh4zNQM/K6x94Og8m0l/llr7VN9nlkoOTW9LJE2DNEA0cbPraH9WjynEmh1j/dqw1TCzmZM1II7Qs9fmHs/+LiamKaK6pmi+qjqJrWVGp6fePNm3Qya8C4wHbA1HgVzEx5JYx/a+n/sLOsUDzjLRurj3lp0DFfWyNXEk6ExAN4Smb/zNz71Sb1LKZNP2ZPPCmVyMnDmPCGAZ8I9UbUtCpQmy8LxhQp+t664TkumyrKuGyBbVy19UewerY2MGLPMyfxA9TakirqT17cGwFmmnf7U+jmtNW9j1k8jTBCpuqN9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 3:21=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set =
to
> one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
> or arena_map_mmap().
>
> It is convention in mm to mark mappings whose pages the kernel manages
> itself with VM_MIXEDMAP, so the core mm knows not to treat them as ordina=
ry
> page cache or anonymous memory.
>
> The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user(=
)
> use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and =
so
> marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
> explicitly.
>
> However, the exception to this is arena_map_mmap(), which doesn't set the
> flag.
>
> This patch corrects this and updates the comment to reflect it.
>
> The pages are refcounted and vm_normal_page() finds them regardless of th=
e
> flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
> thus unmergeable). The one effect is that NUMA balancing now skips these
> VMAs, as it already does for the other bpf map mappings, which is the
> reason array_map_mmap() gives for setting the flag.
>
> The intent of this patch is to be able to establish the invariant that on=
ly
> PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
> in bpf_map_mmap().
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>

Dropped some CC's as Gmail is refusing to retain them in the response.

>  kernel/bpf/arena.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 7b6847200b43..b69fe5e34339 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct=
 vm_area_struct *vma)
>          * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
>          * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
>          * being copied into the child process on fork.
> +        * This is a kernel page so set VM_MIXEDMAP.
>          */
> -       vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
> +       vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
>         vma->vm_ops =3D &arena_vm_ops;
>         return 0;
>  }
>
> --
> 2.55.0
>
>

