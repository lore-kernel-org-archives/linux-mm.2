Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B576ECA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 18:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E4E6B0105; Thu, 21 Aug 2025 14:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5C96B0106; Thu, 21 Aug 2025 14:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32D66B0107; Thu, 21 Aug 2025 14:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F13D6B0105
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:24:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E67C1A050B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:24:05 +0000 (UTC)
X-FDA: 83801588850.12.279FBF8
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2F74440004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:24:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G2P6CRa+;
	spf=pass (imf27.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755800643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S05XX1CMKeNm/D4lxTXlGtmP6fs7IzzZWQyQcXhC3KE=;
	b=hpo/J49NlVXyc+yYBonp8NicXTk35OUNEYNY3Dc/70YdQuraTHezAIPqBzp2KrC7LODzyd
	9jIoaSuqXn1UEt1BTPcS7LaDj2xNajj9Aoro5RX/bbM8wzJd7+WlxkIVQ5CPd/GLzibcAX
	WUj+MQbxQN+loS7c1jb1eXpTgL4p35s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755800643; a=rsa-sha256;
	cv=none;
	b=MPqbD/BYCuZg1yEoBugffcBQbN+6pOA+llUevzKkc1mjPCbfxY8wS8aan5EAPah4zJudw3
	16xfqdGzF95sP8/eNOq1RWc4aAHB+tmFUfs0YldQkdZ5Whwzn9H4j6sFYBpUHSrVxA2ZIS
	X97fkRfJr9Jd/9Mg3ZrBLgb4ixeap2E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G2P6CRa+;
	spf=pass (imf27.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-459fc779bc3so8455e9.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755800642; x=1756405442; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S05XX1CMKeNm/D4lxTXlGtmP6fs7IzzZWQyQcXhC3KE=;
        b=G2P6CRa+uavCnwy+EVtZKYiJ6Tm7PgQ/ZQNCOqPjxekt2sj8dCWw4QRM9lcDGa+/t1
         v74YU3VKCOjc/YAx9dXmFjXv+5w2GInSh2AfK1MamRKNz96C+x0ktfxkoT0gxOpajs9B
         9QAtfmDSsBjqvZvHOlWQbdyPooCxPK00lgUwyb37gi3t7gekJr+4txyS0cOMeUphFBNy
         lbB75LnBUtaHIPqysHfcgl4h5v1CWI49LKI5ScFFctFXUUFofa1xOd/TK33ba00VVjyg
         PccWAyvCdzz/chVV0pEKfYqgpHLcDLudaYNnU7LfFNReQDOzZorRX3PPVcpfMjzuEagk
         OxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755800642; x=1756405442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S05XX1CMKeNm/D4lxTXlGtmP6fs7IzzZWQyQcXhC3KE=;
        b=vLi3A/w5nN42//nDdxGF7tANlXtM+Hx5Zhw4Bdp3GPAj5g0rZNEF5gDMTw3YDpfmB+
         n8uaXcA/qq2EWaD7HDybUbHSGWN/h0UOXSy2vrqmM2BeJeaNau05RRk1ddfINBhD8enw
         Cf/4yBmA6K3/MrrjQvJQ5WIBJe/psBMZCJghgAPAe/kaQXYqj/Gv4d30tRNl+45K3Ng2
         LfaahzSFCfbmIB+0SZVaMs96LX8I+8raeLXHWwWjm1mBR1cspgplefcUP1J+EW9IybYQ
         oj75dVm7ABkTDgZSX77xIgA3JL9oZTTe1+PcOP2a7LVmXWyow+wh6TKymQKKva5cqrfT
         JrDg==
X-Forwarded-Encrypted: i=1; AJvYcCXiNnnD3cCh2af5qA2r2R5o64lJ/x7wtFuRaI9Qp2zjIlFeQl1C11iC8ENTB0Su++s4uEBkYYbeUA==@kvack.org
X-Gm-Message-State: AOJu0YzFyI0Pm45qvpWLuB8/mjS5rqWWct137zK516mi9KeZt0jLvbx6
	4/A1NaSu9qaWxJ9/XxSj/xJ3FkanVXTJtoIQ/TH0Z2lu77+cYFhZgRx5VT5yIGOd6S/wvy+lQut
	c1cOJsuBXIbjMWpy4qon+ukVvNp0wWGk/OiPS2+Lg
X-Gm-Gg: ASbGncu9Ue/ivCC0ElnsiW2U5V+4ptR9T4F9zrXvKrUErveYtyi9xSNGI0UhT+vYUM6
	p/w5JDE3Gx8DV4Qvbvr43gVLt9wRob9kSDnW+r+kxxUVx+CnBcq/gT/EErwWZPXYskiJw3M/k3S
	yS67VOkCdIQyOjLjznt3q0ltqlpHPRUbYEhxy2ilEAl4J663SBSQxDu5Wz0ntNzIb0fnQszQscm
	iiXFEcbYgbCqBLDeMOlW5SA40Ag0houlTu31Gh02XA=
X-Google-Smtp-Source: AGHT+IGAJ/WwMySwd32nkeR5X9Y03nD2OKRkLV9ZWlktV4dgbEHfBj/QYGnOAE1hTkrvp2B/i2b6vwUdUdzxGsf66Nc=
X-Received: by 2002:a05:600c:820c:b0:45b:4acd:836d with SMTP id
 5b1f17b1804b1-45b5178cc11mr78945e9.5.1755800641402; Thu, 21 Aug 2025 11:24:01
 -0700 (PDT)
MIME-Version: 1.0
References: <20250821164445.14467-1-kyle.meyer@hpe.com>
In-Reply-To: <20250821164445.14467-1-kyle.meyer@hpe.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 21 Aug 2025 11:23:48 -0700
X-Gm-Features: Ac12FXxIQjlnaJcpKiZifZHaL_GQKCBr-ZXYxrrQp4nBKl4flBBfpBecptv_Ts0
Message-ID: <CACw3F53KmKRJyH+ajicyDUgGbPZT=U3VE4n+Jt3E62BxEiiCGA@mail.gmail.com>
Subject: Re: [PATCH] mm/memory-failure: Do not call action_result() on already
 poisoned pages
To: Kyle Meyer <kyle.meyer@hpe.com>
Cc: akpm@linux-foundation.org, david@redhat.com, tony.luck@intel.com, 
	bp@alien8.de, linmiaohe@huawei.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, nao.horiguchi@gmail.com, 
	jane.chu@oracle.com, osalvador@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F74440004
X-Stat-Signature: 7hg5qbws5e5rs8cr94zjd1zxqu56qfk6
X-Rspam-User: 
X-HE-Tag: 1755800642-354030
X-HE-Meta: U2FsdGVkX196YSsK3+xHvW5/CgL5HmGFaJyokL4gohJfrE4IkG+rwesP0SEa8JNR1+ye6enmcStM44Oig+Jmhni6MTcAoJ3eArs1sYaFhnAu7CqxUWboA178/UvqsjIa/mJytP973CSN921M3NvD1FlXosWkiLL2ZTsrRyR+zByuufq8eiNpgwjs3BOrZCIjpBAzOwBdd59FfnNNC/tSO4z4IWlDvZmgHbqJP9jgKWugKP3LIiB/AEWuq/hG28avScTnbMNPeWnXPAcS4iKKMJgYOrmX505LhpYMbztYSslop22JKwV5/mBS3uHY644cn0QF7ajCy84Oi2mvMAGu6t0pc9PSrtTLmnVqU9zzO+vsQ8Q57dDeF6TQDOYwOc4NMGTBoyVxJsAyzt+FW2tjf9bnQnUmqQC6rJHE7YwKHXd5H1gA8jA5erD2KIxzzxuxQIaZjbKxs4BosgD1/xW6fXIxt3Ob9d2SoNZ7k924ZxbRlRxL+gxyHsuSbmEzHY8TPdVTIFDrsLQgzWg0qP0GXACsukNvOb1tE/8vFuboo4oFnsBT8qmYlepQMTKVk8WivtNFHtkOAYrNg0ouVFnZ/zFjBaUEXAOgEpccB7E3y/eNRUdPmBmUSRJKE/+LRM/3/irE4YH7Tn65daNct/VZPqUuYFdQ93JpixMhNomuAsp4/5T180vcLXHAFM4u26qEWOBjzBshYXY4xYYi4F7BanJqhUfqU+RMJzu2YWUL6Lpo/GWi7bRG4yrOSMoQuxVlKImEMwAMaJU6CRj7SL+uOaLoc4uwNEKlJmnTX/95UvaYxOGEMIjA5DQIQP5C2lIEuN8f9lqXnF5oEj9jYUldZ3MY4yDZuxVyaZc5jGjnw+0xk703PoSoJIrJdvqScuqIVXorei3mdHq/vpgCENYU/ms3GodghKZt3eT3mfyK/bpPI2VeHz0LFQ+J0kvcPV9RIp/oRpOUyhczBgZJrv3
 zFspjQxw
 Lc78AyFQ5ZZmnvhHWlm11UPKj9A+6KG+zQXRltHu9fw0jHxhUr239g+pAppXhk7yu05SVIagDomtgEJb7yvzE8XxewdmLyNoM3XTXl63UFEmmDps5e8tNwB+yNlM0YbTNxG+QtOkfDRQhDw/qgt5r/2xA+vqrSK6B8Wpml3oOERJAxKXgNxJqNlrRpT+xpM2yudmyGEJCiAD83OJ5eLyNH+R464zlChLZiMnEaVD3Oqto0satQs6M9b/aogytPEVQkYvt8QH34ixF+2nIKZ/r2k3bgpG0XVfirkDHu/QfVus10gCuMYeSSfDqxz179JFts0dEyv2oVoaOQRoYS1WPoQ/NJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 9:46=E2=80=AFAM Kyle Meyer <kyle.meyer@hpe.com> wro=
te:
>
> Calling action_result() on already poisoned pages causes issues:
>
> * The amount of hardware corrupted memory is incorrectly incremented.
> * NUMA node memory failure statistics are incorrectly updated.
> * Redundant "already poisoned" messages are printed.

All agreed.

>
> Do not call action_result() on already poisoned pages and drop unused
> MF_MSG_ALREADY_POISONED.

Hi Kyle,

Patch looks great to me, just one thought...

Alternatively, have you thought about keeping MF_MSG_ALREADY_POISONED
but changing action_result for MF_MSG_ALREADY_POISONED?
- don't num_poisoned_pages_inc(pfn)
- don't update_per_node_mf_stats(pfn, result)
- still pr_err("%#lx: recovery action for %s: %s\n", ...)
- meanwhile remove "pr_err("%#lx: already hardware poisoned\n", pfn)"
in memory_failure and try_memory_failure_hugetlb

This way, all the MF recovery result kernel logs out will be sitting
in one place, action_result, instead of scattering around all over the
place.

>
> Fixes: b8b9488d50b7 ("mm/memory-failure: improve memory failure action_re=
sult messages")
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> ---
>  include/linux/mm.h      | 1 -
>  include/ras/ras_event.h | 1 -
>  mm/memory-failure.c     | 3 ---
>  3 files changed, 5 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..09ce81ef7afc 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4005,7 +4005,6 @@ enum mf_action_page_type {
>         MF_MSG_BUDDY,
>         MF_MSG_DAX,
>         MF_MSG_UNSPLIT_THP,
> -       MF_MSG_ALREADY_POISONED,
>         MF_MSG_UNKNOWN,
>  };
>
> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
> index c8cd0f00c845..f62a52f5bd81 100644
> --- a/include/ras/ras_event.h
> +++ b/include/ras/ras_event.h
> @@ -374,7 +374,6 @@ TRACE_EVENT(aer_event,
>         EM ( MF_MSG_BUDDY, "free buddy page" )                          \
>         EM ( MF_MSG_DAX, "dax page" )                                   \
>         EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )                        \
> -       EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )              \
>         EMe ( MF_MSG_UNKNOWN, "unknown page" )
>
>  /*
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index e2e685b971bb..7839ec83bc1d 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -948,7 +948,6 @@ static const char * const action_page_types[] =3D {
>         [MF_MSG_BUDDY]                  =3D "free buddy page",
>         [MF_MSG_DAX]                    =3D "dax page",
>         [MF_MSG_UNSPLIT_THP]            =3D "unsplit thp",
> -       [MF_MSG_ALREADY_POISONED]       =3D "already poisoned",
>         [MF_MSG_UNKNOWN]                =3D "unknown page",
>  };
>
> @@ -2090,7 +2089,6 @@ static int try_memory_failure_hugetlb(unsigned long=
 pfn, int flags, int *hugetlb
>                 if (flags & MF_ACTION_REQUIRED) {
>                         folio =3D page_folio(p);
>                         res =3D kill_accessing_process(current, folio_pfn=
(folio), flags);
> -                       action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FA=
ILED);
>                 }
>                 return res;
>         } else if (res =3D=3D -EBUSY) {
> @@ -2283,7 +2281,6 @@ int memory_failure(unsigned long pfn, int flags)
>                         res =3D kill_accessing_process(current, pfn, flag=
s);
>                 if (flags & MF_COUNT_INCREASED)
>                         put_page(p);
> -               action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>                 goto unlock_mutex;
>         }
>
> --
> 2.50.1
>
>

