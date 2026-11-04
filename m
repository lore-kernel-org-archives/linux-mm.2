Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1CB6606A32F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7CmQ7Y1
Received: by kanga.kvack.org (Postfix)
	id E77EF6B00EF; Wed,  4 Nov 2026 06:37:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E291C6B05B1; Wed,  4 Nov 2026 06:37:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3EFE6B05B2; Wed,  4 Nov 2026 06:37:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0DB26B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:37:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 418011606F1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:37:41 +0000 (UTC)
X-FDA: 85397236722.14.A3FA04C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A705A2000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:37:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7CmQ7Y1;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793792259;
	b=LGnaPT+KYhHHFKGoICK7fBVme0vpwrEpUobwTMoZGR6WF848Pz3E7dDz3iurrLafQMQba1
	j2YKJOyC1YNJsGpoR1CVZ/1Q0xCSHrXhXcf+uMdcBSgSeaMnj8Re148CsR3KvTbYPjvsMw
	UZwnqmERXCozrlw5t7x6mgR9BkEVyho=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7CmQ7Y1;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793792259;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1nBQHzgHjwK1qwWuQ77Msbc77p13BxYJ1DAXuqstgY=;
	b=0UZgoluI+YUL2+e37rNqEx5IkxqmT06YE/vBt4aHMhtxyJkaibkioSvpfZfoRAdjJ6Ff64
	qBc+Ufa286fl1Nf3GahrSIbJOANcIolm4nobUGHzKGJZD4m3hhOW5NvdJUDyaED48xhd+r
	qRprKWDuGloINdm5CgUaCnjA3MPl86I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7C14612D8;
	Wed,  4 Nov 2026 11:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6CC1F0093A;
	Wed,  4 Nov 2026 11:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793792258;
	bh=Y1nBQHzgHjwK1qwWuQ77Msbc77p13BxYJ1DAXuqstgY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=K7CmQ7Y1aIKZ6+K/Np1YOshfXRsxExJ9e/NdJznm8tQ3Xbk9cpbX+1dDyyW30Qj9A
	 xI5gTIOr8E53Whbqj9Nt/Ugkq73AbeYf0AHK2Dh8hOqQrP8Z2mRvcLrTXWhTR8HVP9
	 7Du1Q3dZ8OO2gVULa1RCy8gK3QjgWwVY50t6de4VBHzOo/XXOxJ6MdfAE2jTkceJf5
	 B1eR9DGM4Deh80VroKwm8dWkozP2W0AzTmILZoKWyJ2QNHkYHFHn+DBFSrtsBCb8qS
	 acg/jYt+j0XFvB9Zbzbs0shTNG1gAP8nVK4oTGBPG1chAbmogONOwLESEgDGRj4OSG
	 U2L6bvsFvYYzg==
Message-ID: <sashiko-outbox-197181@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/5] include/linux/rculist_nulls: add
 hlist_nulls_add_behind_rcu()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Max Kellermann" <max.kellermann@ionos.com>, akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org
In-Reply-To: <20261103113711.1832834-2-max.kellermann@ionos.com>
References: <20261103113711.1832834-1-max.kellermann@ionos.com>
 <20261103113711.1832834-2-max.kellermann@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 11:37:37 +0000
X-Stat-Signature: yjeog3m67py8iddntymbhnmg9tz4nred
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A705A2000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793792259-943722
X-HE-Meta: U2FsdGVkX1/V51xd/voSmCspVRvoliw8/woFTb9PknEHoLHHjMrrvFE/dxPzCPrONE9oqBil0Xgx6b7lquVl8A6V0AOCSWOqqL1Nx9uPizskYcRU1yQ9Gt1iYZmu1m+tdi2CeYH6W2cJFLX0uOUzhrEGdGuc8C6++skhFvf/74bNsjMVLtLhjur7vMCKIuC/PVY7CTfQ3jR+v4AHnUWy8CRNRrxlQtEgniVeo3JMn4DDDispXEBUejdnfZCLJ0qoBPcSSoEAMvmuWJjslkkFr7HV7sTomMcjXMNGEWkvse0YOzjf6S+Jm+YGTtHIK/Wy0huN92o8j/YkKL9yjULPzRnjelHTB3ikx+KYTlJdx5ybZkQ0ocJ224v0hjacH0ichkhDm/W/H1G8EZlOLRjJKvfexoI6XB5BaT4/OOAytiD3fdhPj7c67e3VfWdTXULYivrRTUZzf2sGSL5UNAVM3lx9qJDpMW4jq8Se2Sz2NYrZgBki8dHtQPm1jtlbUo3KkE25xw7CAPyPzpUedzIGLg/CyDEpXx+Jqy/3WIulV8+7mIXVJGo4k7BzOk823laf6/CrqMe7U+5J+osM6cZ3OOe9z6pVIk0XwRb3ZLaRm7UrJtr4qLXbhVE9bysXaBpktdtIHKUfP0qnGcmnwt8JGtJ3cg9IkL6dJCcpx8bS/+uJYglWRIsamIB0oqInviTJNR1TTRy+B9OErL2KU1+3289HbLaf/8bxLqB2lR2f4vfq9JmbNDhZqjBA0kPewo1pchW4z5OxqozDefFQgKxjlLRzVEEVkjDKceUMH/wXJpHzIg2f5RCN4CdUe2ct/4od8noPxILlQligxJli5guRBwzOSMPvKumqb0WPsdPbE74/wCS2gOhprDtBPHTsfUd7tu1X78HiGu9o5V8ophWPQsgQeSNykiHwfV6K80Xqt+fwHaX1U/XLXhSCoIr3PllGaewJ6eHXZGapjVjM4vD
 jUCQUWJN
 XhQ6oudveGrf+8P62BSYJyAUn9pUEesuwSvhccPHCgSXZmwunLVjEb4Y8Pabb5MTvrgfrxZiQZpD3gX5B/H5A+iUr3VS8W7RF/DSlr3UW65Ec9Y0a6InAwTFe9GxuB8Rv15RqHbUKNacPkI2BPrKg6O/uIrzwFvRsgb9L6ihFKZjtJlbdmK3hB13D/dHQFZv4/xBze/bd7bNTIuxHq9m63yjlG/7rgznUMz4qVE8g1gp0QrAfQtfnA7IVyv4g8RTxqy5W/c+umdYKLA7U6C9d8Bc6op+U2GWRSJyCTTcWpxiQeZub8yMpyzJdU3uwa9BkynnapANFNirK5s3TlkBpb/4WyfAhPn6xmiG7IvVj4RNMF7vQyrtLPQT8V/lWN8R+67pcB7AedWGXOt5QsEtlDBg8QzMeXRy5nUyt643Yrp8gPN1vO+J8PuxXzwzF/MRWZbJ0pMJJHYYrPHg0muc2teNnoRYRB4tL2x6Qn9Sg38cbJm+mdLuF4i3C1Eg6KW03JQQa3IV9k4sWu27IhvC+a1T6Tpykls+BFInH+n1Nprk4iKODJC+mkBo5aq5DYam9KntwPGrownqc+SdfJ6HQCGHPjLaPm02/CjfYq0tVTPVHG/+qXiJJcXgbTdERg5utwfRWi1vEAIZsxNYGdsh/GEJb0tbiL+811dMTK+GlMd3OcJA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] rculist_nulls: missing next->pprev update in hlist_nulls_add_beh=
ind_rcu()
--

commit 32c8749135647f4c1c26a14e364aff3736e91e2e
Author: Max Kellermann <max.kellermann@ionos.com>

include/linux/rculist_nulls: add hlist_nulls_add_behind_rcu()

This commit factors the non-empty tail insertion logic out of
hlist_nulls_add_tail_rcu() into a new hlist_nulls_add_behind_rcu() helper
so callers tracking the last node can append in constant time.

> diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
> index a97c3bcb1656e..054e477dd0937 100644
> --- a/include/linux/rculist_nulls.h
> +++ b/include/linux/rculist_nulls.h
> @@ -115,6 +115,33 @@ static inline void hlist_nulls_add_head_rcu(struct h=
list_nulls_node *n,
>  		WRITE_ONCE(first->pprev, &n->next);
>  }
> =20
> +/**
> + * hlist_nulls_add_behind_rcu - append after the last list entry
> + * @n: the new element to add to the hash list.
> + * @last: the last element in the list.
> + *
> + * Adds the specified element after @last while permitting racing RCU
> + * traversals.  @last must be the last list entry, with its next
> + * pointer holding the terminating nulls marker.
> + *
> + * The caller must take whatever precautions are necessary
> + * (such as holding appropriate locks) to avoid racing
> + * with another list-mutation primitive, such as hlist_nulls_add_head_rc=
u()
> + * or hlist_nulls_del_rcu(), running on this same list.
> + * However, it is perfectly legal to run concurrently with
> + * the _rcu list-traversal primitives, such as
> + * hlist_nulls_for_each_entry_rcu(), used to prevent memory-consistency
> + * problems on Alpha CPUs.  Regardless of the type of CPU, the
> + * list-traversal primitive must be guarded by rcu_read_lock().
> + */
> +static inline void hlist_nulls_add_behind_rcu(struct hlist_nulls_node *n,
> +					      struct hlist_nulls_node *last)
> +{
> +	WRITE_ONCE(n->next, last->next);
> +	WRITE_ONCE(n->pprev, &last->next);
> +	rcu_assign_pointer(hlist_nulls_next_rcu(last), n);
> +}

[Severity: Medium]
Should hlist_nulls_add_behind_rcu() in include/linux/rculist_nulls.h also
update n->next->pprev when !is_a_nulls(n->next), matching
hlist_add_behind_rcu() in include/linux/rculist.h?

In include/linux/rculist.h, hlist_add_behind_rcu() supports inserting behind
any existing node prev in the list by updating the successor's pprev pointe=
r:

include/linux/rculist.h:hlist_add_behind_rcu() {
	n->next =3D prev->next;
	WRITE_ONCE(n->pprev, &prev->next);
	rcu_assign_pointer(hlist_next_rcu(prev), n);
	if (n->next)
		WRITE_ONCE(n->next->pprev, &n->next);
}

The other *_add_behind() primitives, hlist_add_behind() in
include/linux/list.h and hlist_bl_add_behind() in include/linux/list_bl.h,
similarly update n->next->pprev so they can be used on interior nodes as we=
ll
as the tail.

With hlist_nulls_add_behind_rcu() omitting that update, if a caller passes a
node whose next pointer is not a nulls marker (!is_a_nulls(last->next)),
n->next->pprev remains pointing to &last->next instead of &n->next. Removing
the successor via hlist_nulls_del_rcu() -> __hlist_nulls_del() or replacing
it via hlist_nulls_replace_rcu() would then overwrite last->next and silent=
ly
drop n from the list, or cause a use-after-free write if last was removed a=
nd
freed first.

Could hlist_nulls_add_behind_rcu() check if (!is_a_nulls(n->next)) and set
WRITE_ONCE(n->next->pprev, &n->next) just like hlist_nulls_add_head_rcu() a=
nd
hlist_nulls_replace_rcu() in the same file?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103113711.1832=
834-1-max.kellermann@ionos.com?part=3D1

