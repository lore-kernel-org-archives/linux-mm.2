Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F49CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 23:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D218E0013; Tue,  7 Oct 2025 19:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A961D8E0005; Tue,  7 Oct 2025 19:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 985828E0013; Tue,  7 Oct 2025 19:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 847068E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:47:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2ADE51DF87B
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:47:45 +0000 (UTC)
X-FDA: 83972958090.27.7CA6950
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 678E4A0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:47:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKgEKKL0;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759880863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8uqJbociTCPUWHWK2qTozHBwaCrC9wN6OtLhywvsgk=;
	b=yjB6P0P6toNm1xlL6ZLpxlxGnqFOV3/f/ITimcc5SkXjSJljNbpiMUvHCESVRe5RN6zkZI
	YODb7WMHV+KvWFslUa0A7xwK3FNbCp1RRU7Dr8G/SzS9JencRIY96t/4iZYt111zBli7Iz
	EDHFxMrpPH44hY4GoVJhpaFaXXAx9CA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKgEKKL0;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759880863; a=rsa-sha256;
	cv=none;
	b=aEWiw95crQG7EeF1/94J4HaOI83PP5M93MbHoP8sjempnJND8LYrgjXuaWmR3nCsU6PySg
	++eFN8KX5qEoAn9xnEJsZhnQ1vEFfQXOB0aejT/2lhO+s4PQYnETFbHr0kzOKePY5ou0Z9
	+6UV5bKR0Uszq7TBg6Ulm4tPL1H/2EU=
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-42f62c671a3so22975545ab.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 16:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759880862; x=1760485662; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8uqJbociTCPUWHWK2qTozHBwaCrC9wN6OtLhywvsgk=;
        b=fKgEKKL0a8Sc70GUP1yeF529xOv4Mr6Fyw1P3SAJKkm9XE/KJg/qHi2jnyjt3Ryukn
         JfizCQVi7lRh0vDJPQGzaHgktt5F+4gwVAR02L8zMiGGhymXLoiVzWx4GcUVvMNKN3TY
         QgO055hN+zB2JpY+mvb4M+o9PUXPLwnEWAw2kKBwS4MRjWfJAn4pOM1vtRp4unnd7sHX
         SHepRuoIzaeU1ACrFlTMvJvzqEyf5eFJ7oEY3R7zNrwOfvEnEf3mqsu6VUDQuV4w1t89
         1LwDPjg7pHujnthE+MDifodUj86Gb/k3wzn+AJ/RSb0xIUwL8cp5bxyJWQXWuKJOsx93
         +ITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759880862; x=1760485662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e8uqJbociTCPUWHWK2qTozHBwaCrC9wN6OtLhywvsgk=;
        b=k+zybYWL2Jvuvek5qNkE30pLReG1AAv7PFdEz0TMT948avyNfsUSN78TiYonvHREXy
         7a2OL2lvm8rBSGd439rmz3O93xP0UMyqxQJY9JqtQgKCQQ5U1JJkTsRVqfLAvRNpgTrj
         1oXfQRVdHqivXXc8XO6bQYmtLVjeITQ4PyWliLxnk3cuSbVT3E1zmd3RgXc/GIcw08pR
         kqarSMOLt2RaRoBK13OwZiLDYhbrOH0HmQTeVjF4P29crxJ+1UYKnbHrT/UPQ7N97r+u
         Py+uZoWvVylhS0U/g6xvMwJ15WA208wboZou9o7glILMdIXZ3oUA2hDnVKuj/fcJAjAt
         LVoQ==
X-Gm-Message-State: AOJu0YzlHWyU2ztrVHGHzKx4TQ7B4ixI8/1Zhk/QGgkp7+MdxXdNDhjI
	pEVO4qpyWocmdOUXNj/2NFFHQLliuU6FTKnTlfXvB36oaK4m+TCVR/5EpuOk8zfi2Am9RKiFq0j
	wvsFISMB6S/IkEloBU+boAp2RU/7nMd0=
X-Gm-Gg: ASbGncsqZQdL5SrD0DBXZSm10+dBWgPyL1gaxE4Q3/xB5o7QYk5KabP4jvksSdlQTsE
	TC4hMYyBwCOY78486BQNkTUTz/hCnOpbz1iDEMP6YNVJtSv6Oa9AW/8QIDJq6EqaMDxhb8VJ66x
	Zs0+Uuks+49jres73uLWYvgQK8YfkmHWsI4FC1uR77QY1whk1ad6lBFDzGGWSCHR/4kIAzVEsRj
	/zIc0eGgn74U5BZiKQLE3aKFd6V2bQK3cD6LiHNODZaExQxh4HvXIlIdw==
X-Google-Smtp-Source: AGHT+IEOJY+PdMJ6V7JuvY1Ev+IpEta4MF1QsBaLVOP1B3MDOAgcBn3U3Oy9frc2219+tl0gG9cbLnSiIgiHzr58/0k=
X-Received: by 2002:a05:6e02:218e:b0:427:d62b:45f7 with SMTP id
 e9e14a558f8ab-42f8743ba4amr12086685ab.27.1759880862230; Tue, 07 Oct 2025
 16:47:42 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-2-74860ef8ba74@tencent.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-2-74860ef8ba74@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Oct 2025 16:47:31 -0700
X-Gm-Features: AS18NWBHmLfrrKKqG3H79QtZObTXiBcAvofr9N7p5pHKmfoJZayOaz3kmQE_c2I
Message-ID: <CAKEwX=Oa3HPQSE5rrFh1DdfoSMtZ4Og5cfTyri5cOqHYzjnkDg@mail.gmail.com>
Subject: Re: [PATCH 2/4] mm, swap: rename helper for setup bad slots
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 678E4A0005
X-Stat-Signature: hqfki7c9gbz79d1f1joni3o3segpe7su
X-Rspam-User: 
X-HE-Tag: 1759880863-391091
X-HE-Meta: U2FsdGVkX1/VvfKtjMiClgi+TgBbuIKFpXAI4zAxXFYNFJhwLNTalDSc6jTzSWLvxW/W3mJrTzLG1iE+r9uyR/IG7ddU6RSXBjfyp5bfW1jHgMdhQxrZAkHlTIVH978mvjGByxfc1Db+HMWdd8CMz/LobNofHfihNdl4VW5m5AKMui/3GU15/Qvn27mgR9kuPkkPZF+4y24bvyB4RZTmnhacq3b/H5wtsDb9UkTFyhCpPdSNyBk6Fn6HT2rRV39Aur6qqC/1400QAsWRFO+LLCbzAMjIOEHrnCItMHy7VlDaN948OTcc8MDRBs7Pq4I6TeImJL6nUn0OoAJaoWBXE/BGlIZ7W58UudPpMHZR+ACHH+zGzkehkl75nW4zTetz0BQP8lHcGnDkwA03DZQ+xvbM4m0hox7RNK9OcBV0jShQJlKOi6dX2rrxpeiElqPPywcMdp0Ev6NPdtQuegTcR+r7XTeSuBkjbfpRWXh/FbcjPMrBVX23tkNoFg46eUyFrCivLiTrSSO5bFIyRPTcZR43U0oogS8XNa9B7DlKKsvo1UeqmIueZ3Gvk6lm9gD95wIX2tJQcPXl5Auz+9qbCNIzLm9vwdR7BX3MqOqHeqUCJ0VxNiagN7eddNDvA9+HlF0K5+m0/BRp09WrJMJz2hT921PGZ/RL/7sYxo77bKaALpV1xsTnQvk9wDbDyKL9a7xmZZPeGcUTyocSvwyc/rqItQJJySaPKaueBTC3RJqO+aY8ZWSjCJd5b1E2TG77XLgXha8XZiYoL1LD1WL+it+bnhNtb/PYTyINFQn3MNibQYX7Tmoqp/RKpaz6GzOgVrkmYNK9J49lVfZWpGjqnWHOgbp/2mCSvPcfuWfUQdHg1GNRec7Pbde8pkypbTfRHgq74DHsrcdjB6x2C0+1csA3nn8p3ZXgNbr16ubdSfNW8V/24Aj127HcGhldXu8qvFsWZimGWqi1GmDOajx
 lWNV2f0w
 AIJwkGXdhUQCt7sANKxILw6dlGaTnHP5PepAM/T9rkxoO4OijDcIt4syGtVT45jsQqcunC6ULywbRiHDQsMng7r2ac7Uq2ybCp3gs5i9Htl6o9gMhPX101Z9lBapcY/GDLX54fxJj0y5P1Spf6u+unUEyxg40+Ydw6sixwB2QzNJCKYk9F41BLkR8NbFglVIA6zGmF3Nib2WHunTGww+QhBQg/7g2DD9+H1pyxSk7g6YexL3NPkKa9TVRA6kGS3CJYjbGrcRvx9KgQJezSRdGHUHguBeyZEtKqWXMDHR6CZ07/14P9knG4+h0+d6VyOrU29hBTgyHCrMWdUMpdY/o3b09wlNpRFwMNht2OwwZuFgGOg2j7eEL2V4P8VgsnlWZDrRlKaiVJALWg/jrQz4Y/tkf5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 1:03=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> The name inc_cluster_info_page is very confusing, as this helper is only
> used during swapon to mark bad slots. Rename it properly and turn the
> VM_BUG_ON in it into WARN_ON to expose more potential issues. Swapon is
> a cold path, so adding more checks should be a good idea.
>
> No feature change except new WARN_ON.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>

