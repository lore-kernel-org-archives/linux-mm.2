Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90408CCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74FF76B027F; Mon, 19 Oct 2026 10:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727B56B0280; Mon, 19 Oct 2026 10:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63D896B0281; Mon, 19 Oct 2026 10:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2706B027F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:25:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE2FC806D9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:25:11 +0000 (UTC)
X-FDA: 85339598022.03.E6035CA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 477F140009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:25:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="SKtg/Ky8";
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792419909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+XXPCAKR9i1PdeuwWGGQvHpwQuIulYAqTmpYB26s6s=;
	b=rlb9GbcPOFLnEsMQ4qOJfRCrdeZmuU53qxsgQycC4OnxP41TrTY55wMTk8Drol3OjnR4nZ
	zzsp0tlpodVf+8g0p4K7nMNvD8dpbgpiVJkdjmOqDrsr6JhfuaiD0aEwodeekpS15VKF9/
	Xqgs4zVujyKEDYG5AC03xLVNbQcnhtA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="SKtg/Ky8";
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792419909;
	b=079WwnUWxKHV0c23WCshB1UuIGdyweFFf4DFjsQOEPPN4laXFp68E1ITtkdgpBBhxWj96H
	W8rq+jZQrGdt37zvFvH59EwPqBQvrtMOlEQB8vwEi4bhyoHjTIc7s4Gs48iIqZSMbxbF7Z
	ewoYPvJ+y9DQXsqiJryJsjrh+1RT+3U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792419908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+XXPCAKR9i1PdeuwWGGQvHpwQuIulYAqTmpYB26s6s=;
	b=SKtg/Ky8hhSqQWZZC70Dii/bKDBmLTQdOKcMZBjxQTA828Yb4ipi6yJ6H55OLrOS7+t+9c
	6ZYgAP2p7QbAdy88FL+3Qa8CDYzriABLc6hwffkbQLU9XPzMwrp9OO3CIGGZq9Wf2V57vm
	OniOr9nb0Qw9CYgIPlG644DqOHRCm+A=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-DrcQHqF1OfCRDj8-GKP5Kg-1; Mon, 19 Oct 2026 14:25:07 +0000
X-MC-Unique: DrcQHqF1OfCRDj8-GKP5Kg-1
X-Mimecast-MFC-AGG-ID: DrcQHqF1OfCRDj8-GKP5Kg_1792419906
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3a987e52306so7919631fa.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792419906; x=1793024706;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t+XXPCAKR9i1PdeuwWGGQvHpwQuIulYAqTmpYB26s6s=;
        b=KEr00Kv2hZ6VsYc1jb18uhrmZHhUNUo1qd/7m9ZKDquStTVzGCbIhzw1mT2F/0IjxK
         o27rSTT0RsVQMpY+j3RGO8Z0ef0PX3pHBUye5eSu23weTuI0WZpc8DXkVzZRp9sIN81G
         oJmLdhlN3yJOMeeH0PldugHJj22+uRZfElxqoa+NffnCLecItB/ek68n6RYXXJg4ikrD
         dLoSFaqJCWc4NTuaD1ea1CC5NodH6goIs8PUP8ffYRVD7+yWOzu0HJUiT5kHT/Jb44Fa
         mSdnoBBHqYF3dwygmlpN0XDvJBYVn63tn4NLSd1VgsSSWDhHUMjvgSYkoq4S8tkqQgYW
         5shg==
X-Forwarded-Encrypted: i=1; AKwUvByieE6tU8Q5075qZZzWtlawTdnEgdrmSkjHnrtsnGbcEy8MQIOhVWdNNzCi1/uGQJZ5QfdL1MagIg==@kvack.org
X-Gm-Message-State: AFq9FYJPl7uVvoi2nTJ4eWi2EZNOL+ifHgO1hJ5+jeJPCRJoSYdpdjUD
	jPxjULcUORu0oaBe8tGslWoN35mx9VgJBMPqAdgtrdHuzv4AIDf2VluQLgg12Nk11j4WCRg8wbu
	3kd2fZ/ahuiyYbH2fgrXDvkf41Rt/Bum6foSZj856RlDTMK1e4H6c5E6Xfvp0B/PTmwNKuYAdn2
	Pw8qGWoJHovIqfAioRFSUSvA1qbMI=
X-Gm-Gg: AYBFou0O5kcYaJSg5sMf+74d1kQE17pyK1uKy2ymCmQ0GH5ghwaMqADvf/DwIEZ1P2x
	elJLXhOWZRouPE33z58Hq7jXfEMXsP2POu+MxEvBG/E/foDTawxQUdbTOjnPNDa2/SeYPp2aKM1
	2zR/UA7JiubTbBfFZET0boGsWOFxUpgpacg5CRdrAZEEiLUT+0pFJBSbVuk07/davzsOeM0j8=
X-Received: by 2002:a2e:be8d:0:b0:3a6:48ce:2b05 with SMTP id 38308e7fff4ca-3ab293008d2mr20364731fa.24.1792419905601;
        Mon, 19 Oct 2026 07:25:05 -0700 (PDT)
X-Received: by 2002:a2e:be8d:0:b0:3a6:48ce:2b05 with SMTP id
 38308e7fff4ca-3ab293008d2mr20364511fa.24.1792419905099; Mon, 19 Oct 2026
 07:25:05 -0700 (PDT)
MIME-Version: 1.0
References: <20261018-bug-selftests-mm-ksm-tests-nohugepage-v1-1-55ed54bdad35@gmail.com>
 <4a6ddf56-af89-482a-b173-18e181bfc3ae@kernel.org>
In-Reply-To: <4a6ddf56-af89-482a-b173-18e181bfc3ae@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Mon, 19 Oct 2026 08:24:37 -0600
X-Gm-Features: AclHuK8zKZKMm5fTjvg9yQro-QDDhE55HWKI1sJCDKDoRQ2ReZ01Whinkm8cRqk
Message-ID: <CAA1CXcDZuHkPpRjE_f1J9Z_6a-JJokAEsCNg+NKfrNviBTt_pQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: keep ksm_tests on small pages
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Qiliang Yuan <odys.yuan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Usama Arif <usamaarif642@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: K_NWxFNQk4MG857FynoE1-1vcuCmH6QhYQ_IYzbpGMQ_1792419906
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 477F140009
X-Stat-Signature: 5zoi8s5kntycfsbcnuyrr96qr59wfz6r
X-Rspam-User: 
X-HE-Tag: 1792419909-106738
X-HE-Meta: U2FsdGVkX1/dyGfXeoIzj5fGdzacdoxiXnBNDot3741osUxZ1BOl18q6U50D9lwEhv2qeSs7rQGtJ1QMnmwRN7BWOIZg4+7Nv0xGH5FOeo58C8TKsSPEQ2ynG8cvJyV6N8q0avzey6uK/ouHRjM1vnTmIlu1QqeGxshXuELrh2Wsh0vokBp6XEEDlDRUy9+cXTP4513HUJii2MAFUJf8sJE8ylKKNU0FMjPIcFgIWZE4XxhK5+upAqoEgrxU6WW49V1Imgv5Slbf3mMEGSqKG77LJMdTW2v4jxHzwHhjmP26myKfZeuiNgxdgUXzZpYpcUoLLNNXqKNLC94BERJUKzfCuxqnZ3+BN8/G/lovyhoCtCN74oXEyWm2PgvVr4f7J9kwm9/I+JHAVUPsDffvn/ws7jcNPqZDKVTgo3h2UrKgwyPETKMV4qs99A0/R3mmh4QtEWNXeDjvta9ygG2hBUNmbidzXeHBKAteHCAPlbDcRjimLXYUMn9iuMcApKpu80Ak7JE+I9Fv3caxVQisvgttndbrRSoUun/W6wKl+P05KbRXD3jgA13Tchh/eo/Zyi9iFy73bBRVtYektPSjQL0f9IxaFQ+v4mMjaSgZ7+ioMGmXiJgjxIPlIG+cRmBFQc30GEfRk9xxKYae8gffbc52KbO2MzHLvDLpUvDHzEptGWjKAoUROJLQZ5WdhFT566JdV3ra2s5b8TM+Ubtug2tbxp3dRlpxjGot8y61CE29qezUWELaDmpOR7f6TzxBidCs1VRai8lIC6cORmyf9za4oW8Odvi8tkAnHkvUHL1/ukL5M7wRn4ZrqlOHB8FbBEooBUnYoqGbAHvftZfPRUK1tMp9HIE8FhzlvAHeuSpyGw7YiKdNOg9+kD10uSKZUwy9f0fs71TNmuqSF2WCzV2euzaaNWVv/j9JKcBmWxr6d9IgAANu5LnDwZOKDI+Ih5y/lOCN6X924sE/Gzj
 OGkPYmzA
 SILim5K1kFMzJMzdElOu8BS0PvsYqV1lNbIyrInXkoxCxkC3pHhPmPH01gqsJzSfoZCDPd1J6SofreGhm05IFD/+jaiYWs8/G6xE/J+E2wu/eVpmST+VOMu3Wj/+tOytsFKrnU2ejAwTDZTVeEiUGu7paWEATaWeMca2ZqIVKGbHfdLMEu+gjIhSDcIVT/8WDsEk4WzkcptM7sGr0OS7b8ENyvqeMkDPShLT41Co+QDDLjEhWksBq5sy1xaWU4MLnI7K5LKy7SRAi0y5fm+1BpTfu54kCgoryoSdV58Ti+gXx3eo7EO6c8vUUDUBT+AnylyahjWQZR0yfF4fER4cErvXWTUfmZSh40uDbSHwoN0gxLQi383lagzRZndmE2spKsBCjlfhSf4WjzfcVWOKXrm8lMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 7:38=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/18/26 06:53, Qiliang Yuan wrote:
> > ksm_tests fills regions with identical data and checks KSM's counters
> > after merging them. allocate_memory() maps these regions without any
> > THP hint.
> >
> > With mTHP enabled the regions can be backed by large folios, which KSM
> > splits before merging. Splitting an anonymous folio maps its
> > zero-filled pages to the shared zeropage, so with use_zero_pages=3D0
> > those pages never become KSM pages and "KSM zero page merging" fails
> > its count. "ksm_tests -Z -p 10 -z 0", 20 runs:
> >
> >   THP setup                     before    after
> >   default                         0/20     0/20
> >   every mTHP size "always"       20/20     0/20
> >
> > Map the regions with MADV_NOHUGEPAGE, as ksm_functional_tests does.
> > ksm_merge_hugepages_time() maps its own THP-backed region and is not
> > affected.
>
>
> That's actually something Nico intends to fix:
>
> https://lore.kernel.org/all/20260609114619.144416-1-npache@redhat.com/

I will try to get the fix posted today!

>
> >
> > Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when=
 splitting isolated thp")
> > Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> > ---
> >  tools/testing/selftests/mm/ksm_tests.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/sel=
ftests/mm/ksm_tests.c
> > index 5fd7792a0d479..140ea833353b6 100644
> > --- a/tools/testing/selftests/mm/ksm_tests.c
> > +++ b/tools/testing/selftests/mm/ksm_tests.c
> > @@ -178,6 +178,16 @@ static void  *allocate_memory(void *ptr, int prot,=
 int mapping, char data, size_
> >               ksft_perror("mmap");
> >               return NULL;
> >       }
> > +     /*
> > +      * Splitting a large folio before merging maps its zero-filled pa=
ges
> > +      * to the shared zeropage, so keep the pages small. Ignore EINVAL=
 on
> > +      * kernels without THP.
> > +      */
> > +     if (madvise(map_ptr, map_size, MADV_NOHUGEPAGE) && errno !=3D EIN=
VAL) {
> > +             ksft_perror("madvise");
> > +             munmap(map_ptr, map_size);
> > +             return NULL;
> > +     }
> >       memset(map_ptr, data, map_size);
> >       if (mprotect(map_ptr, map_size, prot)) {
> >               ksft_perror("mprotect");
> >
> > ---
> > base-commit: 90201351a862182bdabfc1ad1c97b1e1b6ed5931
> > change-id: 20261016-bug-selftests-mm-ksm-tests-nohugepage-1414868db0ef
> >
> > Best regards,
>
>
> --
> Cheers,
>
> David
>


