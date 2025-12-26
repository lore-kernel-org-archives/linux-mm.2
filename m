Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08DBBE8FDAA
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 18:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691BA6B0005; Fri, 26 Dec 2025 13:51:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63FF66B0089; Fri, 26 Dec 2025 13:51:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518A26B008A; Fri, 26 Dec 2025 13:51:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41D0F6B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:51:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7F86137B1A
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:51:16 +0000 (UTC)
X-FDA: 84262514952.03.AE22A84
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id 04FA41A000C
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:51:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RRofBOAJ;
	spf=pass (imf19.hostedemail.com: domain of fvdl@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=fvdl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766775075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zu8hCQ4po4FbAMZHy6j1U15JXWyMO+vyircjZoyuAzw=;
	b=Ay3w5W8FM4v5GBFkGRE0C81Isf2/IscI31j/Ik6/tDW8PcKoyCpkgeUbVkm+kMFve3Nv3I
	3z05XA7QvO5LDPG7k93UJgsZXVN92zZ7+8fBgxTVexgnlm504L/z0uYdjLCndZEgDXVyyJ
	7VXutLPeMx/7i8w0HITtCE9CXQ02Dao=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RRofBOAJ;
	spf=pass (imf19.hostedemail.com: domain of fvdl@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=fvdl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766775075; a=rsa-sha256;
	cv=pass;
	b=J+2nq0xT2XGaBVn2MIAUNDkejN8nP0FkPtDwiSvjAJCx+ri4cOz/uwqwi/vyUsnhG4QIBE
	+HSyvQLkNkRy8ikvsnEzPJ/x644jJmeqSRQY8MdkCsNvA+8EmUICLMt02FVl2Cn0S+Hd7w
	GqMrHUT93QVhpRhbP2u+l6oCZ4lcWGU=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4f34f257a1bso2469321cf.0
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:51:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1766775074; cv=none;
        d=google.com; s=arc-20240605;
        b=QIkioyetM++zv4SnSZiW25K16gWx4x30mPZrx46n0to5MI1DWNfEvLiRa95RuTI4xJ
         A2qw5a6gZo1VcfMQz+aFabsGmeszye7U4GK8owS6wWiFKU49anBrP53wSbvUxtYugqPa
         wF0FjOv8WG01K8Ge5sxv+NajltUqnqUtgNFBeYkMazhtLMTkhpfEIveGdAXqP32BbPDb
         BtESNXHuzJjBEXcTPrE4IzW4h+1tgClG2N39MGMRXnjJZNlkwH1lDN+QdUW/qL5xVJA2
         JflQP9TCcdt4x41+WWF82rfaA21kzDtW2w971IOmH+FcjgzII+rIUSq7pIvfXhvCFd6x
         UV2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zu8hCQ4po4FbAMZHy6j1U15JXWyMO+vyircjZoyuAzw=;
        fh=k/HzTGRvlkXOEzy0PO/ClFFlLGKpYrqL1bY/lc/xBsM=;
        b=BOZMaJoow1JRtMW0PQztnOOi8uDT3xbYzVThABRjY/BGGd9AaoYG07pTd0s7c3LSBP
         gMwT5+nva6JMVvvAZvox5GyaVpGy3PHBV121rmJnbB/PEbjFIEbU+bhawZ4a0y7jFvP8
         F5PIfjx4OkRQgzZXGQcNDqPnePJpwjHMi4r8aJ1OVIGDDJcF+3wK/2c0pcMAmI82TfJW
         anOvhI+0Vf8e48syczQp142gYOFwz9Vj09yt2XfTuUWi3k4rKx3Va5ZX8TSAeZXeu8Ms
         zgCusYx5kFsEuzH5B22tEy25ncIpYy2AjZNFj6MuRtYv+fA/am0Txeo5wpeIXIKA6Jfs
         xWQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766775074; x=1767379874; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zu8hCQ4po4FbAMZHy6j1U15JXWyMO+vyircjZoyuAzw=;
        b=RRofBOAJQV8s2REBLq36h2WfPNqBwfotikx28raWFNVlf6fbjK1LlvhHCPYT9tjV1w
         bGt038hHz266FU7a4C6XaeglR2h5itq5Dm99tXCQE5ZkOtH9RdXLai53ZoKVySsF/gEI
         zmNnxWa2ybjZyxTFjp53hj+W+TOW5TvP2fDBPx9tT8oV5hh499mwQV6hKO1yMZRDqi8h
         kcFxT2OkkoAm7eNFo0gW1hp/lxOdyfKojWrZzjWV1gPpw6lwYu5oRSFPejQFFSMmaO9K
         7Y3NnHF8+MXJo/gD7BsXMNNhOUKKRijAtguGQgX9mJYShpdMK1+gmgIOC/S8vDvw8BNL
         nlAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766775074; x=1767379874;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zu8hCQ4po4FbAMZHy6j1U15JXWyMO+vyircjZoyuAzw=;
        b=MZoJRBRAtddAeW/pR3x2fTnffuqGoF7sHU1ySF7Cpi1R1a8AyOqw73eiIbCwajAlBF
         AqEL1AbYqvfe63lpOr0X5BZM57dCchJ3lsi5EriE+4pvc3NFMOy9YJ/QKksyuGqmbxII
         c1MfER7aNCLDiS+CpbGmB0lFys+lXagASnBeUbWAtEtk0lMv+DcFKl+VMU7KfsQ6bwfw
         Gg6lKlPxyQ4k5wzSuchtLtn+cbrZGt3xCzWv/vbQCsU8WfFCMRrnzIU+R/wEg0wBTe/5
         H86wM8T2aAxaAL/+mWS9JCp9OzPAdzI0f4uBI2rsKYfYbbwT/Wi0l7sHPUF+My+7rEMi
         9m+Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3O+SrobUCmiLjxoejL5xRJOU7xYKhigEiO2+/xGxtu/fQGXKL9pnS7txSY3VD1b4EZXDo1L1QWQ==@kvack.org
X-Gm-Message-State: AOJu0YzuigmK3Uf8jr4HBfP2Vvk+CSj8h157podpgLRqHee2KcXFLPbg
	VszVo/ODEhcNHCzApwWzgDs3M426nRPsg4XwUHRKTTBLrmmJSZTi/5lkUZVXTPsl9t4harBIkSW
	X/hFjMwEotffB/KuTkytrkc7mp9xbYjXvv9nB2iU/
X-Gm-Gg: AY/fxX68ohg160KUAY0Bg36sstymkjKM2AhsPnJn+1HLnZA4VQbRkhJsmvDd0+CORMW
	rowaTVrAuznEs7CkAAAJXW1s0HVV1ikXJLcoIg4X2FE95zOUuznQW5hxOuFCOMsSb6NX58Rjgkw
	fOTAOUoNufYI85Z56LxU269y+2Rpo/iKxmTZqT+N3DOmx0Psjw5tYxsjzBS6/DxtW6he5lAyw/P
	HCbvU+iLvoJOvb8D8Z+Hnq48fDF45qc8DEtrGStCh/1aekG2SGV7v3UCKGTlU+acJ+8ZXg=
X-Google-Smtp-Source: AGHT+IEq4U+/pubmFEFLyF1iy/SH8SAQeVWJvQyCj9FUtSxGLdopUpOJuWK42alqAwvbJpaal5KUx5tqU1Yi/lsvmvM=
X-Received: by 2002:a05:622a:1652:b0:4f1:b41a:a38a with SMTP id
 d75a77b69052e-4f4f3406739mr11717531cf.3.1766775073848; Fri, 26 Dec 2025
 10:51:13 -0800 (PST)
MIME-Version: 1.0
References: <20251225082059.1632-1-lizhe.67@bytedance.com> <20251225082059.1632-5-lizhe.67@bytedance.com>
In-Reply-To: <20251225082059.1632-5-lizhe.67@bytedance.com>
From: Frank van der Linden <fvdl@google.com>
Date: Fri, 26 Dec 2025 10:51:01 -0800
X-Gm-Features: AQt7F2oj1as2rFODNZibMoQz7tUwYOk8bjtP6pDXfE6hrxafWJUhwVRzUIEubxg
Message-ID: <CAPTztWZPGAijX2eAt_tKfF=XDnN2nXHRBXPzh0xsE5Czfw+FAg@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm/hugetlb: introduce per-node sysfs interface "zeroable_hugepages"
To: =?UTF-8?B?5p2O5ZaG?= <lizhe.67@bytedance.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04FA41A000C
X-Stat-Signature: 67wr8oabu8ykqsqdiuk99gscspauuiup
X-HE-Tag: 1766775074-779945
X-HE-Meta: U2FsdGVkX1/4hQhUK7SFyVY6i8YxjcGSLPfqQKAlDDTt2CelxNZ7qLfjJy3T/1+J+Gxih2NRlxZ3isdPQq4LrccEpBgI4ohsMtyYdLot3yJab2+YLIDpXIz6wL/Wmx0U0NAbBZxEl8FnOkzMa5Lg+91PEIsBGd3AoglZKWWmAAvHmylfpCkW/YeDE0T3/iuuEkwjOdQW+2BVYN8g00lCI18SPxZGyx5XUC7C2/nH4jNR3KAWKovu/R24G7NqDAMAQaVMNKTzookmdjYzzaQCGO3lJDM6FtjQA2HVy8MW7HUhZPyGCFFvoHiyYXJli4WQzg6ZXFgxrV/ejV/DPdzZ/2hHpvi/BXh7G17KbiaQrqEmRm+/OWGEasQfRWfMHSuc6/PGwWAWWjlUg2v4Tvv5LcJBRH9g3h2G7xVjChcZmD675rADVVClMZ4sbTVqmUJek2D4J0sNCqw1oijxvFvxPBtx+gqSLrJkjK0tcamK1jSGKKtIy4M2GUSvLYqB/TlE+tKPuW6MURakHC8Frq4GKrpUxCeZJPRjhd4fM1kiAQn6qYaVlFc+aqYZfGRyizSVbxnb6LOw3B8FK6Z7gaJjolHpo6wE9IrLoXbzXbJgeOKCk5bAggOmHsvsvOXEqOyDvGXO43TW4OJjcqJFSTe8YFo2nzrSFxJsKBgbgyg9l5YVJaTAc07HXUq7lDmTuOGVn9FM9jd/zF4RFdEDGOzv5b/sgryQN7fCiBOsHBugUNKkhayb1m9D6HJGwLC0dBMrA6LWRXUgxquOjtGFY5v8qhMc3X/lN5bYo4pBZzbItf1bz9BoT3htNnP8m7xu9VEImuvm6oyAaB31b2IVrHjrg3BC40WKalyVSjzEHFEdYE5wqYo2HyTAYrxLhNZ3ydIkQO+TzJZ6ZRmsV5teyidHEA1vSdm3DNQaYkTfvczMdd+i9SyyRL7scYZHtbtiJrKWzse6UII/Qb6WygRjHWX
 kdXA2JUw
 3C/o2KUfXahs8nqequuXYF1MrZKz/+31zBvKGR7YlbvGTuwdDcqyFJmjbdH/Um82DV//MH5zzI0X5RN6YUF5UozOSYzTTNCbisUghbHD+Yk8soiKDqKhdF4IO0RX4L+wAR2S0oqy8D0ma/7T3s2G/oLmCZMa70OsogErLRFrXR3XGDkC59UNz8IQ9IxqcTa4uiaVI/IDbbtmxbPFcWrzv+b4zB7TlxTA+hDr0QYRS9wx6aoxVAE82pdRSUbMJknlS8hITJpTFIUxPopLhOJ6SJx5n4pvFD9MbhFiVXhcC7WBUiTsbZ70YzOFwsiuu273XCzZICulmJehpG4A3DsVQj5/iKAvQcMfD3s981XXtlYXtoYqOzuPgpQ0hkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 25, 2025 at 12:22=E2=80=AFAM =E6=9D=8E=E5=96=86 <lizhe.67@byted=
ance.com> wrote:
>
> From: Li Zhe <lizhe.67@bytedance.com>
>
> Fresh hugetlb pages are zeroed out when they are faulted in,
> just like with all other page types. This can take up a good
> amount of time for larger page sizes (e.g. around 40 milliseconds
> for a 1G page on a recent AMD-based system).
>
> This normally isn't a problem, since hugetlb pages are typically
> mapped by the application for a long time, and the initial delay
> when touching them isn't much of an issue.
>
> However, there are some use cases where a large number of hugetlb
> pages are touched when an application (such as a VM backed by
> these pages) starts. For 256 1G pages and 40ms per page, this would
> take 10 seconds, a noticeable delay.
>
> This patch adds a new zeroable_hugepages interface under each
> /sys/devices/system/node/node*/hugepages/hugepages-***kB directory.
> Reading it returns the number of huge folios of the corresponding size
> on that node that are eligible for pre-zeroing. The interface also
> accepts an integer x in the range [0, max], enabling user space to
> request that x huge pages be zeroed on demand.
>
> Exporting this interface offers the following advantages:
>
> (1) User space gains full control over when zeroing is triggered,
> enabling it to minimize the impact on both CPU and cache utilization.
>
> (2) Applications can spawn as many zeroing processes as they need,
> enabling concurrent background zeroing.
>
> (3) By binding the process to specific CPUs, users can confine zeroing
> threads to cores that do not run latency-critical tasks, eliminating
> interference.
>
> (4) A zeroing process can be interrupted at any time through standard
> signal mechanisms, allowing immediate cancellation.
>
> (5) The CPU consumption incurred by zeroing can be throttled and containe=
d
> with cgroups, ensuring that the cost is not borne system-wide.
>
> On an AMD Milan platform, each 1 GB huge-page fault is shortened by at
> least 25628 us (figure inherited from the test results cited herein[1]).
>
> [1]: https://lore.kernel.org/linux-mm/202412030519.W14yll4e-lkp@intel.com=
/T/#t
>
> Co-developed-by: Frank van der Linden <fvdl@google.com>
> Signed-off-by: Frank van der Linden <fvdl@google.com>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  mm/hugetlb_sysfs.c | 120 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 120 insertions(+)
>
> diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
> index 79ece91406bf..8c3e433209c3 100644
> --- a/mm/hugetlb_sysfs.c
> +++ b/mm/hugetlb_sysfs.c
> @@ -352,6 +352,125 @@ struct node_hstate {
>  };
>  static struct node_hstate node_hstates[MAX_NUMNODES];
>
> +static ssize_t zeroable_hugepages_show(struct kobject *kobj,
> +                                       struct kobj_attribute *attr, char=
 *buf)
> +{
> +       struct hstate *h;
> +       unsigned long free_huge_pages_zero;
> +       int nid;
> +
> +       h =3D kobj_to_hstate(kobj, &nid);
> +       if (WARN_ON(nid =3D=3D NUMA_NO_NODE))
> +               return -EPERM;
> +
> +       free_huge_pages_zero =3D h->free_huge_pages_node[nid] -
> +                              h->free_huge_pages_zero_node[nid];
> +
> +       return sprintf(buf, "%lu\n", free_huge_pages_zero);
> +}
> +
> +static inline bool zero_should_abort(struct hstate *h, int nid)
> +{
> +       return (h->free_huge_pages_zero_node[nid] =3D=3D
> +               h->free_huge_pages_node[nid]) ||
> +               list_empty(&h->hugepage_freelists[nid]);
> +}
> +
> +static void zero_free_hugepages_nid(struct hstate *h,
> +                                  int nid, unsigned int nr_zero)
> +{
> +       struct list_head *freelist =3D &h->hugepage_freelists[nid];
> +       unsigned int nr_zerod =3D 0;
> +       struct folio *folio;
> +
> +       if (zero_should_abort(h, nid))
> +               return;
> +
> +       spin_lock_irq(&hugetlb_lock);
> +
> +       while (nr_zerod < nr_zero) {
> +
> +               if (zero_should_abort(h, nid) || fatal_signal_pending(cur=
rent))
> +                       break;
> +
> +               freelist =3D freelist->prev;
> +               if (unlikely(list_is_head(freelist, &h->hugepage_freelist=
s[nid])))
> +                       break;
> +               folio =3D list_entry(freelist, struct folio, lru);
> +
> +               if (folio_test_hugetlb_zeroed(folio) ||
> +                   folio_test_hugetlb_zeroing(folio))
> +                       continue;
> +
> +               folio_set_hugetlb_zeroing(folio);
> +
> +               /*
> +                * Incrementing this here is a bit of a fib, since
> +                * the page hasn't been cleared yet (it will be done
> +                * immediately after dropping the lock below). But
> +                * it keeps the count consistent with the overall
> +                * free count in case the page gets taken off the
> +                * freelist while we're working on it.
> +                */
> +               h->free_huge_pages_zero_node[nid]++;
> +               spin_unlock_irq(&hugetlb_lock);
> +
> +               /*
> +                * HWPoison pages may show up on the freelist.
> +                * Don't try to zero it out, but do set the flag
> +                * and counts, so that we don't consider it again.
> +                */
> +               if (!folio_test_hwpoison(folio))
> +                       folio_zero_user(folio, 0);
> +
> +               cond_resched();
> +
> +               spin_lock_irq(&hugetlb_lock);
> +               folio_set_hugetlb_zeroed(folio);
> +               folio_clear_hugetlb_zeroing(folio);
> +
> +               /*
> +                * If the page is still on the free list, move
> +                * it to the head.
> +                */
> +               if (folio_test_hugetlb_freed(folio))
> +                       list_move(&folio->lru, &h->hugepage_freelists[nid=
]);
> +
> +               /*
> +                * If someone was waiting for the zero to
> +                * finish, wake them up.
> +                */
> +               if (waitqueue_active(&h->dqzero_wait[nid]))
> +                       wake_up(&h->dqzero_wait[nid]);
> +               nr_zerod++;
> +               freelist =3D &h->hugepage_freelists[nid];
> +       }
> +       spin_unlock_irq(&hugetlb_lock);
> +}

Nit: s/nr_zerod/nr_zeroed/

Feels like the list logic can be cleaned up a bit here. Since the
zeroed folios are at the head of the list, and the dirty ones at the
tail, and you start walking from the tail, you don't need to check if
you circled back to the head - just stop if you encounter a prezeroed
folio. If you encounter a prezeroed folio while walking from the tail,
that means that all other folios from that one to the head will also
be prezeroed already.

- Frank

