Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D746CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 23:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DFA68E000D; Fri, 26 Sep 2025 19:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B77E8E0001; Fri, 26 Sep 2025 19:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4658E000D; Fri, 26 Sep 2025 19:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3378E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:53:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5241C066B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 23:53:57 +0000 (UTC)
X-FDA: 83933056914.19.EEBCDF0
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1EBBD1A0004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 23:53:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vC2GdAdg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758930836; a=rsa-sha256;
	cv=none;
	b=dVF5psuieAWlIUJOr+4HoEdYXy0Sye6r+94SsKhRVisRtvER4gPTaaI17T80TjmmuZy3eC
	3sogQJ39+0ZKhrBqTK/DuiQk20m56QEYJv6zS+H4b3XaQDeGrp1r+uxNKexV0o1DtRit8R
	OfODBvJK4Kap9CSYCkweNs4PuwTpSfc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vC2GdAdg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758930836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTTfzN21DB87uS849xyD/v280VXLHTvOWoRCskFIjR4=;
	b=3ovocTuHGehWLqUdhudDdGlM3xfcU1b8FHWmXY5MgicLznE+6EdarRVM1g0qPtLEw18raC
	xbGpSGvyrFWjPerdbqM98AgquGe/71Zw1Do/LEQF3fKjeVLQqswCI2atZ/WcGLuTLMyrg5
	AzntBt4A2uK9wBuElyG8INlhWg3so+o=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4de60f19a57so217951cf.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758930835; x=1759535635; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yTTfzN21DB87uS849xyD/v280VXLHTvOWoRCskFIjR4=;
        b=vC2GdAdgQs3v+kJqPz2Y84oQprk7Er9cfEpuHS4QdJAfGRZfjLv48PmGGmrlXIuYA0
         J4mhyA/0jybIguvXOlk99Iin0+4ImuUGRKrVBHEdwhMU035YBNd47xKuBqIckMG6DlbK
         9v0ijJnVK+70dIaOUYyzGhv4UqysmjfwyGRVAv7yxtDh3xTMAV/dUKTdcjFNTx+lyPIb
         JHklKdM552HT0XEYzI8L59ujVFPSE/46/G0ZNWLwbnNqo5Vrr6r3jj0kxluo7B9agyD6
         XMd2B/gifCMnyxuI0S5YgYqQe16d3YPgZu0o0MfKf5V4tGDKjaDD4ztICScFbOZwtecV
         6Siw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758930835; x=1759535635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yTTfzN21DB87uS849xyD/v280VXLHTvOWoRCskFIjR4=;
        b=g9zKqWc/j2we7aWXI1FI62rDD5RX3+UlRuXgMrDsfBVT+7+pjkj68O/ffYK7nrOMxc
         bmtDCmV3rufKW+/qCF3j9sXNElVO6H1mIG6y+4WpEBQrYi8M7wRVDugt8ir+6RSmhgyW
         1hH2pQfBCs+7uWQNM3WzLF+53bHQ1MZXZRwCWCcsAuhnIE+1ckA4gpoYmPMpCkN+Kijz
         pQBzGaMJXA1bvWGHE+OsDNUbUjV4sipiwv7vMg8qEyIvzVCcmB+pv6Cu3N6oIq26PCKY
         ilUN3wLDRYPwmtDQXHTgICcw6nn47tGldQ2tDSTI0c25zGSn3WExZNqQc/1pL+I54SZX
         pRQw==
X-Forwarded-Encrypted: i=1; AJvYcCWxILKDLnJg4ba9NCrIlFNwOo6I9JfGA6LbqeG4KZ0pnXWB0jEldvPYoHbnx5WlDSitVJepg4fBGw==@kvack.org
X-Gm-Message-State: AOJu0YzyeqHTSmwJ+4TK/mjZzTIyONpsT1fXNcg/YW7pHZmVkqxWr6+E
	/hxhwYXOFraLZQrFlvhiklrifXnFuNuCKv8zlnNLBRF7KTeKyjjdt2ptUawILVpkiOWG410vHpR
	+atk0JWpGPXysm+X/sGMgQiU2Pq4q6LgUQHzfWA19
X-Gm-Gg: ASbGncuM0uMyb6u9A+kvV8J1fkenDw4epHqWaUFpEkC1r/TIE1e7Er7+tstoTdcJdZv
	7DlER1sa4jcXgJNdtOPrnNcelKzU44QUKA5iSrT0pbUhY5w0ROgQBlpLfWj15ihU58RonkLmT+C
	A0uCyhcv0hpVCu1Fn4FITdvm1GfW31TkSZSwx+B5IQ5hnz50mNzseFkRcrjjXJx0qYS0iu2j1SY
	SlrblnqhMWk
X-Google-Smtp-Source: AGHT+IG+CDxpZDq7cerRivG168/JBuGbhBn4m2N2beYMkKs8KBXjG99FU+kZal1/3nty/278PwQXV7HRqzkoe16OSKU=
X-Received: by 2002:ac8:5d88:0:b0:4d0:dff9:9518 with SMTP id
 d75a77b69052e-4dd1c1e99camr9522481cf.12.1758930834670; Fri, 26 Sep 2025
 16:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz> <20250910-slub-percpu-caches-v8-17-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-17-ca3099d8352c@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 26 Sep 2025 16:53:43 -0700
X-Gm-Features: AS18NWAdMKYxmKVYaznnVjN0ZRmLOyAT5xqSY6fx4SVJ-14lr5cKqrxUTfebiPo
Message-ID: <CAJuCfpFrFn01Dx88vYaDnByRraE3qPvO4rfMaortgwYyVsybZg@mail.gmail.com>
Subject: Re: [PATCH v8 17/23] testing/radix-tree/maple: Hack around kfree_rcu
 not existing
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, Pedro Falcato <pfalcato@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1EBBD1A0004
X-Stat-Signature: dr5btdkegiedqpdqh94rtew3gam1tko3
X-Rspam-User: 
X-HE-Tag: 1758930835-130900
X-HE-Meta: U2FsdGVkX1/u9ImudrA7WyMPKBjMJHIhKnN3cWuUQ2sufp6qWQgOvPaK9Z6q97c64zW1qitfe/LVuZ0QafMsvEZp/l2KS31yqEXVo2HhTWfS8imPLYbMuFsjg2KIoxZ22ISG0PgC/I8p+W2abdrOyEE4v0lGOOT4NFWSGGh0QSObgC8vR+uKJtV95GVVnBPsUV5AIjyKvmVXDPrWhK2UNhzJgfQCJczYqlcBq7w0U02hN5ifydCaq9FPVwKKWgE5aQI9AgYn0FYm7OeKIvw9UxSJunLypURznrOmZpJrRb1NlJFUQAeVlbm16V2KiiEAlCMNjhZbdy8vzl0X7tKEcOFJOlv1CaM9TqWRMKYTUufHYTxDsvkvUy6PQyikwFpVIedbc5Quf0MaltN4RtU9v8HaFNDGSoKPFo44FacvXq6n+EccYzhqMroFELt5saCroUjCAWsevbdiHr/RoQvnZFMj6CyB/GV6qNyLFKAllGObW0+JOu+iuVNS4rpbyRc934+jSuA2pQXCt4RGwADCDXhF8l/fSey0+9lboSRDR3tu8P+9cZ+dPH69Vp2jvuxqZocLY9H/l9X5XPAaj9Gc4WPz4RXc92TlkHIGtb+pi7TURPaciNuQ3uwSUvwraj8gHxK9pDzm15dJh/rteHDcUP5oQiPO6vc+khMXrUwMz5y/gUtzcafwXiyOx/3H7HRdKDafzqNxZBbcC7fgTkNhASs+vK4+DAziZfpIUrRNp/l8OX/rpQR9FCoRRqehlJHJnd0wHCtfnc0oIdLKDKlzHkWsilRB7508ijS5kxNA34vbDzo/Nj1dQNfAiEFwJXQgHaZyIN2YX0pI5eQyrfdN5XbVt+iNFqHHvqcbBFuTjoc8X8u/Q7Q6+XmpuIZ/7bGuenBULojfBMjZi51TutjWvuA3zIUJVEMkA/p813tmBK6kNaPezw9jtPf0+4ErnA7SDTfj6JKRa6jL3oV1ASk
 yzqivcT0
 BYsQ7X/h2l7Ube9DgMXhVuGPDxa1VmoCtZE95pLfUoXYb5jaNChJcutC0oZBwHFlNUtSHbzYYCaeyMqaIUunMYT84vnMLmCtnQEpQs24d6GjKPNJXLkXoTPcp0VZ5oQINyNSd/erXbkSds5BA3x00vNW1MnlOXLHBQhzwySdQQiqSuH+B0sjS5B1oc/CNF+6icKhmbZmCmAtSDogeJp7z3uuhCU1nfmc1h1BSZGyctbBBYvGGnMQQ1qMkJLEBG8pkIhUPLVR2b04NncQr3SHZBgGnnUgIyVepxeVYnezZuJWXGj/UWbcfPt758w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:01=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>
> liburcu doesn't have kfree_rcu (or anything similar). Despite that, we
> can hack around it in a trivial fashion, by adding a wrapper.
>
> The wrapper only works for maple_nodes because we cannot get the
> kmem_cache pointer any other way in the test code.
>
> Link: https://lore.kernel.org/all/20250812162124.59417-1-pfalcato@suse.de=
/
> Suggested-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

With one nit below:

> ---
>  tools/testing/shared/maple-shared.h | 11 +++++++++++
>  tools/testing/shared/maple-shim.c   |  6 ++++++
>  2 files changed, 17 insertions(+)
>
> diff --git a/tools/testing/shared/maple-shared.h b/tools/testing/shared/m=
aple-shared.h
> index dc4d30f3860b9bd23b4177c7d7926ac686887815..2a1e9a8594a2834326cd93747=
38b2a2c7c3f9f7c 100644
> --- a/tools/testing/shared/maple-shared.h
> +++ b/tools/testing/shared/maple-shared.h
> @@ -10,4 +10,15 @@
>  #include <time.h>
>  #include "linux/init.h"
>
> +void maple_rcu_cb(struct rcu_head *head);
> +#define rcu_cb         maple_rcu_cb
> +
> +#define kfree_rcu(_struct, _memb)              \
> +do {                                            \
> +    typeof(_struct) _p_struct =3D (_struct);      \

Maybe add an assertion that (typeof(_struct) =3D=3D typeof(struct
maple_node)) to make sure kfree_rcu() is not used for anything else in
the tests?

> +                                                \
> +    call_rcu(&((_p_struct)->_memb), rcu_cb);    \
> +} while(0);
> +
> +
>  #endif /* __MAPLE_SHARED_H__ */
> diff --git a/tools/testing/shared/maple-shim.c b/tools/testing/shared/map=
le-shim.c
> index 9d7b743415660305416e972fa75b56824211b0eb..16252ee616c0489c80490ff25=
b8d255427bf9fdc 100644
> --- a/tools/testing/shared/maple-shim.c
> +++ b/tools/testing/shared/maple-shim.c
> @@ -6,3 +6,9 @@
>  #include <linux/slab.h>
>
>  #include "../../../lib/maple_tree.c"
> +
> +void maple_rcu_cb(struct rcu_head *head) {
> +       struct maple_node *node =3D container_of(head, struct maple_node,=
 rcu);
> +
> +       kmem_cache_free(maple_node_cache, node);
> +}
>
> --
> 2.51.0
>

