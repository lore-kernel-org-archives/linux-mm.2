Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6352BCCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 22:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736DB8E0118; Fri, 24 Oct 2025 18:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E72F8E0112; Fri, 24 Oct 2025 18:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D62F8E0118; Fri, 24 Oct 2025 18:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BCEA8E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:32:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E966D13C545
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 22:32:29 +0000 (UTC)
X-FDA: 84034458018.12.EF954B5
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 305551C000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 22:32:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BZcuV+88;
	spf=pass (imf18.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761345148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUfYp53fu94dUtqrZRLYGe5gVG2u++6KcY9W1vIJxhk=;
	b=Yyudbj5NQMeuN6cRRhjq/Fbps6458o/J7GG9u32ktP66HZN0tynnybqVVPAiNC4/FmgfgO
	B4vPT2coebhevFOTBjC9HiFjc/NJtu93oS3cClmzjrYR5l1E5hFhE3lVt6+c7DMVHoqK7k
	Rbi3PupT9cZqIs4egMkpjDvIt78tmCc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BZcuV+88;
	spf=pass (imf18.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761345148; a=rsa-sha256;
	cv=none;
	b=YJho3dq4vaGwY/9ZeXUQ7tvYb3PA6fxoypd5K9z549y7aNArKJChUt4LVyhEk8uRxOyDbW
	zyH6e92ZLWH1vyvzYIAZpK3n9eko3UvXMNgVWl2JQZVZTThaVids/p0KWCn0x318Gmojp7
	oPzzmEgv/D5izr/iKxgYAWobgS+sG60=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4298b865f84so1381572f8f.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761345146; x=1761949946; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HUfYp53fu94dUtqrZRLYGe5gVG2u++6KcY9W1vIJxhk=;
        b=BZcuV+88Z6gEYmzGRgPKLZJ1zYgTrHKe7XUxLkcxMNUZrpD++hBeWSei5oF1E6wcf1
         1X881GcO2/Sl6rIiJhfBzVWclhCpdiIWCmWV7RQcy9zzg85iQyebTeHHdzu6ICLyJufg
         K3mj3tTG0htqislMgGdn5r5KCKElHAYB71r03siC25E5xnR3EXtKkQPKyB+22UNKJXzR
         lBU20SjKKnJlVBdV0ZZD0TiuR3s5hbTMXYJ0eiipNVTttWsJC1b89lIqnqJssZpV3r8i
         dMr3UDtMqC1Yheqaq9TFXyeG/nHcNi8Aht9B3LsaQ/QKNZXhVxgfDOa+d/KJ3sqf8J/D
         ASoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761345146; x=1761949946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HUfYp53fu94dUtqrZRLYGe5gVG2u++6KcY9W1vIJxhk=;
        b=tEiemganxxTJcdXyfD3HOVAcUfQOUhYNtFLYxVY8GfnYOtn5qlmJvqYs3N6PWrQ2qC
         Z6Wsz/biw69irwvr8HNdJFPijeshk0/pqL19ZFv7FqQFqs+/H+UImja9h4vGHtgVis+5
         HTyhy6D87QcNRPB+/kntTFdcdLGoBxxK0Zv3NbnzIHhCJTieAVHxqXrs0k7bopvU+6Df
         Lb16Yg5pbhuey0mrxEgZTW0QkQfhsq1SK+8xu4EZ14njrBEs/GLjycUtsb5Ems7l9lgX
         4g1xeiZAfVE5BZrgbRVxFqCvFyRQ8K+NooWi35lLvk20anzJ9H5FW0d4KRF6mexZjS52
         yEnw==
X-Forwarded-Encrypted: i=1; AJvYcCVlN+6KNlZCSQnzS5JQ5aJJHZdyS8RNXjjMJmWbh+35aoRD91Jexc/1Ojv+APQk6ZdnwMpCRgCUow==@kvack.org
X-Gm-Message-State: AOJu0Yz7wD/DQ3lOGlF1akfpR7LWzpUlIO3pEh1c+8OJOibd9hj4Sr5J
	7/0hHMJZ/CWrwnwyPQpMqjDMxABjNcdfWlEMweYwubrxPohbQtCNQn0P3LcmFRND3byVSX3PAvK
	KpuBDt0iEHKL/2ZpyBJDmqqK8SEKOJpI=
X-Gm-Gg: ASbGncun135Ss1Ki8An/oix1JhGH3peDXTx0iJx8OKKDfOqE1DSfqxnJmdnW4BiGNqy
	30NdENwCw8hzDgqr895wAwZC4HTFAphPoIZDA1UJw8DOqMu85qTQmY1JmkAxWzmwDDXcJIOTVl6
	Z3mgwclVrU47ZGSVXU9KkM1wBaGDlNsye/B08xBwM0YUDuouJCD7J6i7R0gF10+G3yZ9G1ENTxC
	kV0yCRahZ8eNViQ6HTou7IwYSt0nGCeuOmRu1mS8lS/qveN8zwqszvQiyXGo2qBRpmfYlrC4D6C
	yGRGmHOFh5oyCldfMw==
X-Google-Smtp-Source: AGHT+IEk6kGBtRPTTE7UK+dCfFed6KOoSdQT4rrIfK18Wcd+iW19phRfPOMaAHllUvSpuZUGkBdwBVCywmTCWEggRpM=
X-Received: by 2002:a05:6000:200c:b0:428:3ef4:9a10 with SMTP id
 ffacd0b85a97d-4283ef49ddamr18538286f8f.54.1761345146453; Fri, 24 Oct 2025
 15:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz> <20251023-sheaves-for-all-v1-12-6ffa2c9941c0@suse.cz>
In-Reply-To: <20251023-sheaves-for-all-v1-12-6ffa2c9941c0@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 24 Oct 2025 15:32:14 -0700
X-Gm-Features: AWmQ_bmYxy3mKLZGuaPpnI1v7zjS22cZzV3kwSBj_coWNlSrdgc_1YOXiQjgS1Y
Message-ID: <CAADnVQ+nAA5OeCbjskbrtgYbPR4Mp-MtOfeXoQE5LUgcZOawEQ@mail.gmail.com>
Subject: Re: [PATCH RFC 12/19] slab: remove the do_slab_free() fastpath
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pws6in8u4uqpx5hhqfk64s34nufc7bz6
X-Rspamd-Queue-Id: 305551C000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761345147-438810
X-HE-Meta: U2FsdGVkX19+qcEHVgw4Gjdwh2I1A6C4hdTkJfvR/ckCQKeFEAwm+Vwvrr/KqCBQCnL9jIhW28RGPz+UVShu7f9w8KIRt3ETAC7rh8PbWU9kzZrsz99Ly5Ao4a03BQmoisJT+A63RYjtm4QrmUwDSuxBOLuquLmnsAO3x1tZzg6hMqmV4dzst7650kA+Xjjcz49tdPwdYau5NsGLtdZk2eCnDO4AKFf6vD2kexUA4ZcuGFdlXUPxTZ62Sp1q9fGKD0RuaOW6YwD9UVHspIse6KSeKFIqGA2r/RDziIe2lGrPSSKG75mQVoXHXrrs9N5ubKRHMApt9Sk9EN5tnIEIEINp+enpB9T4DcHzLkPg2UkInTylvclICP8rcQgkNFHJlUUd/RFwFpBtaz1rj5Uc2HVC0bhsgTFCHzG4iyNezvZnIeJ6pxyuJvDLeVgOO86fMTe87sdECRS58/GCRE97SZzLx0BoBwPBaqR09nkzrb3icpjlJ7SMqtBJwN3qADtBkHCmFKPi1Q/v7ysjnXdoyc4Q9aQNar1lL8NHfAJ6k+d9XMssddWTK0I1dsKR+pqyZKTvTCrWJSX257HbCcHkVhu5xqqxWTcNQdYT7uT0ZEfUYQCQbUSSSIF3uVtempUdBeZ2Z9xGcRp3sX+kl5myDEDUAFc4ZU1tW21SXTHFacfHaKn30CYOF5+VMMG0xZtGSTg2pcyDc6+KjADWwzovzW4lxy5PUOfEjgvVZQI3gfC56wU4MLPdsz7jmQXZGQp6hrPiY6bZtpX2lWpZNlA6EDggn0oSZ5vPaeRaeXdJc+YBoVwWuinIu+1v7phn+/MN6ZuRX36gafSlC6zfJxL7cLHgvg3uoILNXvrdbO90SbbSgyhYmQPDJxP65FaPK7tvNBBUvulBvaH9gLoKsdh6iYa4FqRMm+G+uwX1mZLW498jTRuWtNIYgfw7dWORMqxUzPdHp46IDjYU9SE86nE
 V//6pHkG
 kjlhHCJ62bZubej+ILHnvHPJsaCnwdSCfWlN8AOvMWVGv7xBWEtDiwaLRhBnnRYlHuzCYqyHfzjCAxhPvI1h8LcULzdfKSKCcI9MC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 6:53=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
> @@ -6444,8 +6316,13 @@ void kfree_nolock(const void *object)
>          * since kasan quarantine takes locks and not supported from NMI.
>          */
>         kasan_slab_free(s, x, false, false, /* skip quarantine */true);
> +       /*
> +        * __slab_free() can locklessly cmpxchg16 into a slab, but then i=
t might
> +        * need to take spin_lock for further processing.
> +        * Avoid the complexity and simply add to a deferred list.
> +        */
>         if (!free_to_pcs(s, x, false))
> -               do_slab_free(s, slab, x, x, 0, _RET_IP_);
> +               defer_free(s, x);

That should be rare, right?
free_to_pcs() should have good chances to succeed,
and pcs->spare should be there for kmalloc sheaves?
So trylock failure due to contention in barn_get_empty_sheaf()
and in barn_replace_full_sheaf() should be rare.

But needs to be benchmarked, of course.
The current fast path cmpxchg16 in !RT is very reliable
in my tests. Hopefully this doesn't regress.

