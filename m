Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C41EC01B1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:05:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF5FF6B0089; Mon, 23 Mar 2026 06:05:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6406B008A; Mon, 23 Mar 2026 06:05:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B953E6B008C; Mon, 23 Mar 2026 06:05:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A483D6B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:05:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4674A5C065
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:05:40 +0000 (UTC)
X-FDA: 84576896040.26.322133C
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 341EE40012
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:05:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pjw5gMIe;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774260338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fe8lRRvyxJtfwvETbBb9tJ6fU3C+Q1Xi3toWGC7el5o=;
	b=E4lNo8K3G41OTDkNrrVk6cJXjh/fjaj/vtPKwvg9DBDzk5hQ5p09ZeB6bYMiwsDQFQLcjC
	uZNoKWOeea4qBKM3khJ9UUso7rj7dp/ZO3guCPRzrdYMuY7oTNurSeZC9Ed1wVB6TGW+Dc
	tu8L0zGuoEoNb1aLqcuA+AVuNaNBUR0=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pjw5gMIe;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774260338; a=rsa-sha256;
	cv=pass;
	b=w+pvM09eDhmIN4ABgKEQwpY0KN2EA4bvcHOZRuEky5UMsZhMdO4OGIttrimfB7tZ9XVHsQ
	GkyLX7M5RmIx4urJxBHc+fi5yKHRHSsOjH9Ur6I2FmV54Wfo8lop9I5n5RyJsoxXcjfgAR
	4JiR0VHawk6ieCpqNBfOjAr3VLR37bw=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b9825ba7f9dso425605066b.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:05:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774260336; cv=none;
        d=google.com; s=arc-20240605;
        b=gDhcp+0xcTo+0iNnSsnYkkQXycrm+G3jJefwB0HypMLGVkX6kCAINyYUOKsRE53BgP
         2vNcjRyBRfy1EZObNHs3nFz1ocMIgnplYLbVA0rUaQIrCAMawR+v7T8p3osrDl+UKLoH
         4HxA3aotwTjJoHmwARr4X/9GyOHoU95BB1ztgonOARS2EeapwreFK+6zktgG1cQqOLRl
         71iJrcKqoCNPRgsoBXwgd64ZGaGcwpTk2lxj4gREf3lcOm21fU4cVjDSTC0UXQhAtDnh
         Z274cKR9D+GZaIh752Qs/FVeb7ka0ZSgzWw7HMIXSu1eUJKoztOJjZiwm8I5n5hm0jki
         ZMtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Fe8lRRvyxJtfwvETbBb9tJ6fU3C+Q1Xi3toWGC7el5o=;
        fh=BuJsEL+/Dk/jCMbmsHhvb5emeUo2Y/wCpkPzj2DeO5I=;
        b=UPHaD/R6eyrzDqnAC2CJC5YSo76lzfk2XPGqptAiGc8ZRaXE9S+Baj2WB/fqROJRf5
         mq051uxykz8AQ+GO4B3lYIijNTNeaTiChXnmYqirQZLP02hSv0USjVWORI+IqGzJZ7uG
         vk1tAhCYywHitSMzncLD6Awzzsd2Z7e6fMH99TsZV+SFDDMSc7bj/oqbvDnJJuGr92QS
         kkfkysaQfpx5rGsW2ZM30IK/RPdAduQWbjGrKP2twQm9x+eczjTKcp/aiXtYmyNovKvP
         VMD8SAyjdcMueNxCCY3CNJLp7DZqPWAceJIleDlnHPG8cifg1V9C4UC6BND2twizPPeD
         jsNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774260336; x=1774865136; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fe8lRRvyxJtfwvETbBb9tJ6fU3C+Q1Xi3toWGC7el5o=;
        b=Pjw5gMIeEWX2jTpfhTcg8hjbbERFZgyqtV9Djyewv416AfYrKsxlyRBkDEmNKUruur
         UzeeJqDhLAVV7eOQ0EnOA2X5fs96S0iyPoOTuvHY6Gv+iQyGNXbJ6LvC/6iWhr5A72l/
         tGK49FEM5e1i1w2CHDvvovzGZa7PQ0c5gJV5XZ3mAUU4DwdxJIZX5KtJ3RjN9Twdp4iY
         ByBJPhuC0UILHHfObuKeSdXVo76ZwcXaXCplSSl+QPA9CSo1ZxpE/meidVcUfO+3VxA5
         X1ppW+cZg0WmVjRGdrXOgN9KbxPwS0XdLAKzfT/cZI4bN3UPIQ1E49LakeB+pGuii7BO
         jdhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774260336; x=1774865136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fe8lRRvyxJtfwvETbBb9tJ6fU3C+Q1Xi3toWGC7el5o=;
        b=Ao7pxhCfqgvrjItNjo97yxEVI0YMIro0lDwevqQ3CCFm72WD1RmtCRsr/cefe1rM4z
         Y7nwMUhWVVtBtrIUF1FyXxntEJ6JMiTEBgx0GlBOSoNi3HOVELQTR8ANkaBkK4ZqpEcT
         RuTRGUs00WoI/pNo41RA4OFmuXzbR+0LSDWeU6mu30sYFSkSlnijuHIYxojU6qMpEMok
         X0v5zgloZJqRHGsqa7VSa0HTVL7JayVy4BiaZcRcv0ZrOjRa95OoXDbDg/ju6DP87WM/
         BhX9+pSF06L1uPQTWfl7tEujji4eUCK4L/0RD8X+GUdQ+wciD2BFSdvXXFsDwZEdgZkY
         K01Q==
X-Forwarded-Encrypted: i=1; AJvYcCViAqjxhHpNjSm1TnFHPJP/9t6pScDbBval5vsYJ5eZudG5FL1JQpSRXACFH+idh1+Cr8w14w/RZg==@kvack.org
X-Gm-Message-State: AOJu0YzFLP6CmhCZpjHpkHDDc4jvjIIoAu8ytkWalWhVZ4/eAERGcaCu
	LlnzkasjTLlLnDmHm8B0CH3btD88jO7NaXg60IHqIRNc86Ic9rEx0vgQRiXacob6jht9sbbXJJU
	24pELfJwcmMi5SibWrgnKv7p0NkRdu8Q=
X-Gm-Gg: ATEYQzyqp1yyg3uGoIVD4dmz7/3JiM/3UoTiqt+hMu+U49ZiWVUMLORH/188hV71X7D
	Mzg+kf5d5ZA2ArYPsOihP5jHSBaeAKHnHqJpM2/yaEW+l+6eqs3yVOxT1U+B9Ewoz9yXC/4TO1f
	ot0KUTKn3nAErhknwaom31mCv0ZOumpByv5/HmbHP290NknIWIskR5q2laCtiJl2+shW1kYfEkn
	EI4U5b1KtGlo6sT/46frtK0hfu7nomJIyYXSQqwsNGnkV+/XqwdfSB0spqczJZOeTqdGV0thomj
	E5yRMf+xG38/E7nQqtX+kINxWIx033Hl979Hvz9e
X-Received: by 2002:a17:907:3e21:b0:b97:fec5:eced with SMTP id
 a640c23a62f3a-b980f5bc9bfmr1045896966b.0.1774260336020; Mon, 23 Mar 2026
 03:05:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260320083339.1813195-1-zhaoyang.huang@unisoc.com>
 <CAMgjq7Bhi_2cgWUWpW+nh4dK2B9N_AbtUf+EJCwBF-d5rvFySw@mail.gmail.com> <CAGWkznEoX2c79E7HiWMSv5Vk+Afg0P4rUgEO=gs1p65kBY-BfQ@mail.gmail.com>
In-Reply-To: <CAGWkznEoX2c79E7HiWMSv5Vk+Afg0P4rUgEO=gs1p65kBY-BfQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 23 Mar 2026 18:04:59 +0800
X-Gm-Features: AQROBzD3LBRQ9IyKKzdSlhiX-e3wTPOcYI_AjXhB7nN9IvrwnZbQaOhi6HhhJ9Y
Message-ID: <CAMgjq7B09M1X2FAtQX=HPTZjTO1=JdwQFZxLY5E+4OQ0S__gRw@mail.gmail.com>
Subject: Re: [PATCH] mm: skip dirty file folios during isolation of legacy LRU
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Matthew Wilcox <willy@infradead.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 341EE40012
X-Stat-Signature: nou6cnn8r3cdhhsegu4tyb4xb6cd9jts
X-Rspam-User: 
X-HE-Tag: 1774260337-610064
X-HE-Meta: U2FsdGVkX1//mxuyCDXRWw5dntoiT1DHaXkXi5mEhYi9OaK9vpVI7QF04DCvIFzIUnkxlxqQuHcaZAw2pEshh1aOFTfkeTRz4gR1bEwR8w6sTPqISw7G85QFWTGFWilciUXGP64DVRF+m76s+IOxMRkEJ3ZZPNb6WHlcrzpeq4exdJSympTcyT8FbpOozC+Nc8M4GeQ2JiDhe0lCWg+Bk28RYsfC5ARQzR6vnEAfTU6BH3pvVrYdHwyxjo1QBXv4i4Vq6AZBtUEF6sFPxzRr0lwH8zf3Z657yKVFaCidoXQ8hSAuqMvhuwWShXEsQZbYT+Y8PvtAfFZUTiDHwJl49/AJ/R3pVD4p8j0ug5jMDw3BdbdTQ2QrR4Y/Fjza6uGnDTL2UB5ZFnfq8N/b1QZ+AWGhUr4z4muiRx2pD2hWkYBCaUepfscrHKjx8N6iPYwp/NSZ59PEves9q4t7Ch5ylFMDAyo2YefmzzYTD5MmM6VhDg8V9XRqCxcpNKxYt/k80nCToAW3U8AjTlbZ2Lerf4LJulhAyL9urRvb1umrjoe17AWsBW169WXvVfVUZ+X1+NNW0+HHdb3YWla5buFTMRFnNPB7lP/AyckjKwYCp+srCki2WY9CBFZF0QVKL1guf/uJjQzWAMGYPqsUwVfqTM4OueJPAxUwONDbs+FgqdfqvJCfAykLFQzuDDNVhLr1lIq38daPntQTo7wvakpWQoXlj+OlZyhK94vozICnHMwB0OmJwX2tLkVdElWBnt2r38FIhkqjKn3+NchUw9KdLUiYwD/FVKR62exrm5fezXf6OaTkW+aD9uRjoTDr2hTu/xw8+gF0ZMOUKbburMrsWRn0FUow7dPV9b1KWX7WKukE6YhaOuT9HBgA7hsziVzFCOzfPpohGhftARyEPFSIU4nlIrnqCc4jZJv+HQgihJqufMWa2UQHYcZuYBIyfJHQUFFcMDjTa4J7ttTWDAf
 +meajhIQ
 8rpeTBlyxVjdye3CB8yhv8fIAAY8AfIspm3JTe6TGnHZcbq140/cVVseORaWPa3Ue/zwKu0wtOK/UYuG7ghGGuFAX5rzw3uUkg2YoY//ZjsDUW87gbVVkGrX5HauhJpS+nVRipJaK9WMn4DOWziSjzinI0CMYybKPO2HuKqlppIZSyVqOL3RMhxTWEXsasGZxjIqdmk/M0/K6oCQS9JROP7RezYPwky1en1vKZMUe7WlzkywMFQSeoJP1vJcfotsn4/mLl6DVgrf6WzhHEmke8ILEe4MHvLUjbHeXuxnTqM1VTr8wLEmSLalWfpUjvEsGKQh7FSRfh0WLxwVY6ZR5AcKyxGMcHzZfxeYOZEgsVKtx6BM1yVivWF57klQMJQMOStfXKsp/RleQmp2nVxDksyhpjorTwqBWDneY+CI5qvKuMJgYJog9UbHwPpJIuIeKj5SQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 5:17=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@gmail=
.com> wrote:
>
> On Fri, Mar 20, 2026 at 5:20=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Fri, Mar 20, 2026 at 4:34=E2=80=AFPM zhaoyang.huang
> > <zhaoyang.huang@unisoc.com> wrote:
> > >
> > > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > Hi Zhaoyang,
> >
> > > Since dirty file folios are no longer writeout in reclaiming after
> > > 'commit 84798514db50 ("mm: Remove swap_writepage() and
> > > shmem_writepage()")', there is no need to isolate them which could he=
lp
> > > to improve the scan efficiency and decrease the unnecessary TLB flush=
.
> >
> > But you are still isolating them with this patch, you just adjusted
> > where the statistical update happens.
> sorry, I missed the above information in previous feedback. No. The

Hi Zhaoyang

No worries, feel free to discuss anytime.

> dirty file folios are moved back to lruvec instead of being isolated
> under this patch. How about apply this only when isolate_lru_folios is
> called from shrink_active_list which has no worries about stuck the
> inactive list.

Hmm, No? Reading your code in isolate_lru_folios, you do "goto move"
when "folio_trylock" fails. But for "if (dirty || writeback)" folios,
you only do "nr_dirty +=3D nr_pages;". Am I missing anything?

And as for the different behavior for active / inacitve isolation, I
don't know if that's a valid optimization worth the complicity, and
the worse part is it may break the dirty flush wake up logic, as
shrinker may never see any dirty writeback folios now.

