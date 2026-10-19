Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C09606A319
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 22:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MNJjoBHi
Received: by kanga.kvack.org (Postfix)
	id B37F76B0107; Mon, 19 Oct 2026 18:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9376B0108; Mon, 19 Oct 2026 18:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE456B0109; Mon, 19 Oct 2026 18:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76E726B0107
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:59:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F18571A0791
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:59:19 +0000 (UTC)
X-FDA: 85340893638.21.F77F58B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 05D5740008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:59:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MNJjoBHi;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792450758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NP+3b+jU6Pt4iOuSZnbpymTlb8HWqG2TQ0sFosc2A5w=;
	b=pAbi3LHw2uIkWN+19H2IkRoZpGKVxEvfxviKhbJFNQObAzgXmW8njGjZtiusgsCEHF+nLs
	gutRVroRUcVY2OP3+ohsgrXb4ge5vhsGVqgE16P81qOQEqnXXjBU0jvylAVsHLWXYSNda2
	6zIajqriwOMGMLbi9scYqIut6+ZS6ew=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792450758;
	b=LnYnOoRuoejOOjmk1KFXIfqsUxNhDLBl02UJYl7U2kNrl8vf3hkF6EiLSTbzYdX9FQYmMF
	41jSZCkqIe/WlBRIvHiqOt1SyKagjS3Pw1qzmDLQHDSUpT3ui4bNvVsGhbmTkS6ttBdE4H
	uWyRH659tVPh5T1HG7+IycPzG95PE14=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MNJjoBHi;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F083447F4
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9DE1F000D4
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792450756;
	bh=NP+3b+jU6Pt4iOuSZnbpymTlb8HWqG2TQ0sFosc2A5w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MNJjoBHimcx20jKOW/IMI37c/TKoKlswb79hTiw2MdNfLWw6RtMo/Kc7JRdCJTzqB
	 fJn7w1UREkj6XcT6297vv9bdYz1XAvGUVOu3ymMNNlSBkpwuxCASqvPE4CmpZ4Ydki
	 JaaE9aHmuOJo4O5tB5sjJ6sngJ5LvXvu/sM42xnsg44Z65+npkpPPU6h888UegA+0F
	 mnzt5c7t+N00nhn0meFBWPa1fsL0tgUwc5EzK4+/HihprhMZDkpxamkTI5ARZH3Z4K
	 CZasiwVMSXAiHBSUhU4g6OCC9lk4I9O5tP12zDOiI1swu0nwgZojFeyx3NOMkNgHR6
	 dY8pL3gyiQFpw==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93ece7a73b9so348176085a.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:59:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByDvyhFeRgQJ3QNct0itBBg8svXWdpYC0ohL5zZ910vl3fu1pG4yHZ1q6re4xMv27Nk+WMioRWBMg==@kvack.org
X-Gm-Message-State: AFq9FYKlwHziqtiUqvIsP8BuK2cd9YYhU6BzwNm5qrzycrW34mO5wDpL
	wVjDCrzR80sDgP39mCPpkahYb38LaXtJpprq5bn2VLwkHMkne/coLB34xYb8mJnLVV0leqgMJQH
	ED1CQy+yZznHn2AvknyBWlhBOKTZGw7g=
X-Received: by 2002:a05:620a:40d2:b0:93c:6507:a6e2 with SMTP id
 af79cd13be357-93f29dcbfc2mr1496702685a.65.1792450755627; Mon, 19 Oct 2026
 15:59:15 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
 <CAGsJ_4whqGRQ4JY5rLLJZU=f8u5T75qHkJYQFDoqZSx5c6EBHQ@mail.gmail.com> <CAE5sdEgR3C30xMayXJkWOECQTfADHgNE8Qf9=wjB5eGimjwLYg@mail.gmail.com>
In-Reply-To: <CAE5sdEgR3C30xMayXJkWOECQTfADHgNE8Qf9=wjB5eGimjwLYg@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 20 Oct 2026 06:59:04 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w2ZSe+jot17v1SUqeWsFaj+DJmckZA=js3FQhUt66Fjw@mail.gmail.com>
X-Gm-Features: AclHuK84pjR_fzDL7jQ8QK-VnmwljGUwwh_bnpTXVDshBNZKrTLHqRnrEMTBSJY
Message-ID: <CAGsJ_4w2ZSe+jot17v1SUqeWsFaj+DJmckZA=js3FQhUt66Fjw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref
 with memcg disabled on cmdline
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, stable@vger.kernel.org, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05D5740008
X-Stat-Signature: ytarqe7onfsrhbcz13gjytmit86qyog9
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792450757-509029
X-HE-Meta: U2FsdGVkX18p7MaIQEWIC+kTVYjBGWK77B9TM9eaCTzcFfNOZOA4ZNJ9oNqNkZA/sr8vYMRctKCguhpk5f01TlJn6JRN4WSNzzO5vDU01ZBpGydUMLo26zpBcaP7tOUR8IomjdBXmYeOhtdhLgPtjrZLBLoXw0u7u+9h6tunRMDtWbG3xnb07Jk2hJU/8D4serTbbJAr/637nnbNT/oEUcR2gxckcNYZCS3C5ThbgNp27FJxQjBQ33Y7sPoInX6BL6HLXhR8mWDHe7kDlzQIsmcwbJ97Ch3T1dUtV1KbUzKOLcnPZeAHPFhZaHxA9ZBF+gIHXImPzf0VhXhmNMvKK5GviDwHlOOt98x6+a9n54NzKO6TDBHiRq6BbsMcCYiupCXayB4BI1wNrB/n77yqkkOiXuRv52OpvTYwXqDhrDg1QZF2rGOBazYs/qWZXZr9oGvo7cdimhArvx1DqWb2LmPYzdZOoNtgI93GUKBZiMirqk0obrbOZHcJSxn+Dl5joyNn+lAknF0JkCFuD9aDyer4iZxk69aGJ1rPqO7EM7e6ymMVrzj7MwF3pBQ0JlgmtAUt+VVIlPwuUIDwKLWvfohwPSVNzHzLMKxdTXd00RPvJ1XNG1I5Q7uv1ldHn1rESt/MCDbpW8/gwOZRK6Y7t79qqm9+R1eGZO/+xCiUiotQujMcIDhlLLmmrpLTTfb9mPO6PJ8rlTBvsiJewRyIeR6Kv8hJ6Kqoli3rw5UMb9CjmqYY8n9KPtm0PY1k47dS2jN5FtslPrZodvu1ruzks+ajQrnJ8V/+ZWQ4qwmZ8qUBHVhsKFEkt2OUo/TN9kZsTI8gH7bf3nnIoHOki5bxvnZbB9PoWWpVCaHi+rOll+vkOdfJyJCVmh+QzdGi3QlwSindv0Y2t8dEDj6F8p20tUSMr29bjqtKtkmATscrXdtKwZfxP68SrGSNFwF900Y/FkZdFRmm+HsJxS6ngix
 eUiRaaJG
 2bCl+x0cC5YrMiKKkW2PsI3HzlBahheQyeGQCzrvzjT391iZ/WXAzfaUydvJvlSbg30qoRBDUgp81phbqPitGYx07euh4xym+1bpTjUpD5Y+K1yL5A0Q0u25qDW/V2qtcHRyLOdlXs+9yqpAGGwSiE6YbECsDKj1S7LYExAfZLmxCM/VosGnuFUcJJcQin69seBEQ+k2yLt8lz0+Od3TZYi9L/W7cOoB7To2nW3lICRaqkBxi2ilmlJKZwUzllT2PuIRYa/URyDErCtMp0t1QHYnMWIaDeViJVJahLN9Y23KaOaFi0TE2/1/ns4AUcVziRx8wU7L73x089IgKcKkQDK6RrGkMewsE0lvWWrWbLRvNhiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 4:37=E2=80=AFAM Siddharth Chintamaneni
<sidchintamaneni@gmail.com> wrote:
[...]
> >
> > So this happens before any folios are added to the LRU and before
> > the userspace init process starts?
> >
>
> Yes!
>

Thanks for confirming.

> > > Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists=
")
> > > Cc: stable@vger.kernel.org # 6.3+
> > > Assisted-by: LLM
> > > Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> > > Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> > > ---
> > >  mm/vmscan.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index f11491ee9ed5..0c57e4f1eb15 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -5253,7 +5253,7 @@ static void lru_gen_shrink_node(struct pglist_d=
ata *pgdat, struct scan_control *
> > >                 sc->nr_reclaimed =3D 0;
> > >
> > >         if (mem_cgroup_disabled())
> > > -               shrink_one(&pgdat->__lruvec, sc);
> > > +               shrink_one(mem_cgroup_lruvec(NULL, pgdat), sc);
> >
> > What's a bit weird is that even if we fix this here, with an empty
> > lruvec, we still won't be able to reclaim a single page. But it's
> > hard to see where we could break out early, right?
> >
>
> I am not really sure about simple bailout logic. Please let me know if
> anyone have any thoughts.

No idea. I also feel it might not be worth doing, as this
only affects very uncommon scenarios. Some unnecessary
reclaiming is unlikely to hurt real-world workloads, so
there's no need to escalate this into a fix.

For the patch,

Reviewed-by: Barry Song <baohua@kernel.org>

