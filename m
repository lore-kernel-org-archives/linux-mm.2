Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8362606A333
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 19:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=asftpg/e
Received: by kanga.kvack.org (Postfix)
	id 79AF66B0847; Tue, 24 Nov 2026 14:00:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771E76B0849; Tue, 24 Nov 2026 14:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6883E6B084A; Tue, 24 Nov 2026 14:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2037F6B0847
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:00:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA18E120ADD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:00:06 +0000 (UTC)
X-FDA: 85470927612.08.2CE3B80
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD707A0018
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:00:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="asftpg/e";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795546804;
	b=ND3TzgLvmqNYOrPpdpb3lj426GxzTbq7iJQLm9Ra43+ZUgqr+LnUuGH2NHYwTmuHWFUOLO
	ejoP2yucLwyMiySRe3AIo+5AL620j0ln+m+CqJ9GkmA3L7oT3SisVdfsOnhCMCQlgw5Qx8
	BgOkUod67ww3NEdaFH908lfYDCiay+8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795546804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pI18bHQi+lJnh+lP+mc40mct9lRe+QxMEvK17p079oo=;
	b=ih5DFU1IdIateq362g1aBRGjQZRSxHGq8D1F3uE65L+BqgbqwGkKE3PDEhrDf/zobGupeM
	41WoeVQiricVDdMMrUAS6kJmAtzbIgKydKWS8UBqww829Whdl7UwA9xdGkdsC3HFe2DPll
	A1Hq+Iu2Cb8Xy0MAmeEbkX/Q79RwrCk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="asftpg/e";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb845433b8so139375e9.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:00:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795546803; cv=none;
        d=google.com; s=arc-20260327;
        b=NVu67onr4RpU0A6Hv9xDwUXc5rz12wOHJZNJ3DxerazXWrE47G+2/+Zfj/aI2S9cnz
         eoXuy0ExsCCtXycBn0kO+iLWvn/csMSo3a9EhGUQ4K7XfhE81bA8US1tD1ANX6XKSpsQ
         9o7EcoG8eOSTB2o3U/Mrp77NWSg1NZIa6zLy3zA5NgBe7MUAJKIbXzKfxDVci20fBFHM
         20rO0Zh6uX7+Pte5uzQ4SJVfqMGh2aa54sg/Qqq9kPq/SjVVSrsGf0EW6yfxvNY+Torn
         WNnw+RnJJg6V+RZ51wRMWretrKTrmkpKETntREl/LwIal/TvG9Ek+g6WfIXHqmxN0wEt
         ueBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pI18bHQi+lJnh+lP+mc40mct9lRe+QxMEvK17p079oo=;
        fh=oRFblCuvlgsrdZUsPMb4rBYKXgXmu1Mrwmdut31JI50=;
        b=jxD7qjnlg6rVlawe/JmfvwxdIniueXOyxs/Uj8hfVscaC4rY5iN1Z577PfUZqZtPRP
         NSAg2B/y4udP+0ZtvhVMZ1o3Tr4ZlDoXBw0u2asCwriNvzP5xf9uNvPFWuX5SNVmoIsw
         2rWmrR0dvUjnZnRmtkkasKvXDGpXnoEGP+5eCN6/9Dviut7JQK9Sp3dvnm7AzFvfCfMi
         2GKZotHHH7YgzoJUcZGrdgEBGAVy1gopJQmHnloygzWzUk8MuycWFBhy09u+9HRzNDEV
         Ehc6klxt9n74u3VRBxxhrN2tk8vvAVmKHEYmYUG0AKBNWdVXILLXbj5KC7GdQQZf61yI
         vpyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795546803; x=1796151603; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pI18bHQi+lJnh+lP+mc40mct9lRe+QxMEvK17p079oo=;
        b=asftpg/exSy8RAZHUvSSPTbgQVKaq2JPC49Z6NK8qkcS0KxfzTuMfWdb3IOQMw1Uty
         kz0OGnFzHJXclq5/UfZfuhgwPeBMGNAxPv3sGv7TgX3h8VN/YgpfTI046qGcsVfhnWaw
         KQQ5sGmQal0RdUREc86WxlkP3gN6AnJeqf5Ektat2dLm84MaU1N77WUY9FORdu+9izud
         mPyuG5ppaIm89TwvPRoyCidx1LYmhepLwH6nmgdQkMUAc9sF3oN6t0fb+Af7R/N7hhKp
         cf27TJdE+E8ss1/dgZzbp1DDhJziVkz7vhiiI8x32O0UPuVvtI8WpevoeUYgl9XhTeEE
         ceWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795546803; x=1796151603;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pI18bHQi+lJnh+lP+mc40mct9lRe+QxMEvK17p079oo=;
        b=EIxzVhoPhzjzDKw0LhDahtF365oGueq1CEQ/XB8Uy8PeIu1Gi+M5TNPSZJ4pvaaNrb
         rH0QeslGRUriAxNMHu19LyrHz5Ty7+DL7y/ps6tbwZCfc/07e7e2B/s9D7R0rnFWZPLV
         sfp6TFPk/wbwKs/DZ1Cu28225wuvKxBd8qbd2l4d+dzP3EzeYXZxjpGfif2UQXcJv9m4
         CvtXFKy2FLgYbENCbl6nbt9EteGBpyNliw01TVye6rf2mWz3pzYz5nuYzvoLyxDIyOOU
         MrMm1MEk7517ZAEFMoKvpf38bturE4KVlb8zUOistH/c7FVyUY2krI3x1dfGSaU/Oz/g
         lYcg==
X-Forwarded-Encrypted: i=1; AL+hErHD2xUEsNeNDD8cyOfcmD1uo/9OYLqfKuyrPGIOiKL2vF4upshfrzCt9HrnP8osYxaHUWKht24oPQ==@kvack.org
X-Gm-Message-State: APuU4Z9JxZ83avpu1sb5Sjr/YG9vyUcy6FJMEw51QZ2OMJHI0D5EZNqw
	/WIlSDNov0KHSXgexvqT7RKug6RIG5zWhMHxMsz533/KYx5upofYN9H5qPl6XRUFxOnOGhihFgb
	AB80h6ANi14zOanA5+QvpdeCpo6ftpjx1cWuSQ7rx
X-Gm-Gg: AZFdTZczeVyIy1spfIYT9K6mq2NuLa3z/M/8dLfxIIEHkb9Vi1ZZRETY+YTlEIFj1aM
	5OfyrZlESUIKxCMZBS+GdcUe5SsyeNDS5UaaVMOgJWQYaFtuS8tXW/SSGLCycepLid2uEO+OX1F
	5uVqQd1lVfkU3XFZTW5PMgfRIu5NqyVnOHvV1hXMbeq6Vo/pV9TF6xfhPvGywZ4Aq7xVEJDzLm6
	+bqXbFTDOLCD/2ZZw3xPMSkboBJUroB6pO4EMMNjdI8TWPgBXJHb59L7VH6oC+CQ+CIqFZngR5+
	VMsdoFQV5OT4HH8u3KC4nyV91V1ymCPwmJmV2wde4ynxvd532mP6LNewFZbHeeDQ7sGN1nXG1wS
	LLTqpg7uZTPg65HYarvVjan5soA9f3WyDvJCEB5VtL1iwGLSg1/Axm7Wy2nd4+geGDYwHS75ss1
	Rsbrv25cVChLplMfTZ5R6ZQCI=
X-Received: by 2002:a05:600c:4ba8:b0:4bb:5e6b:2dfc with SMTP id
 5b1f17b1804b1-4bb91646004mr2422425e9.13.1795546802578; Tue, 24 Nov 2026
 11:00:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org> <20261117-huge-pfnmap-fault-races-v2-4-276007e73bcb@kernel.org>
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-4-276007e73bcb@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 24 Nov 2026 10:59:50 -0800
X-Gm-Features: Aa3M54o4WZZXMe5rkCzAWiCKTf4u9AcgtxpDdtwUOt0YCIX4IAOM1qzNi5J1mGI
Message-ID: <CABdmKX34z2s-7KE2+JwFSQRN3eGoTy8bs+KB_hWXw0YbF9msLg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm/huge_memory: only compare PFNs of huge entries
 on huge fault insert
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
	Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
	Roman Kisel <romank@linux.microsoft.com>, Saurabh Sengar <ssengar@linux.microsoft.com>, 
	Naman Jain <namjain@linux.microsoft.com>, Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>, "Gregory Price (Meta)" <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CD707A0018
X-Stat-Signature: hiajimmwid58ykp6pxknyyxkwsobtora
X-Rspam-User:
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795546804-978756
X-HE-Meta: U2FsdGVkX1/rRjdnhhWQBZEuNMiUrYuM2WCLGsQYUi0McvCPr0sBnyFhJXDzsvwHZX7VNe7Kf/ZWnKwqwGVPfseyEbeM+0G4ErI1ghBY+6l7puvrgA4s1D0SuODlq4tJqGZG/IzPkT/JQyUvIrRy9/UkuGfT189e63xxby6i7nhKkycUHw7BwUETqJvW5YMtEanGgyaB1EjqxL/SqTbQ3XBfm+tpH6oDDxyQ4ttt75FXV0veR9MWHxi8f/bYTtvACjJdcKT/yH3xtRhP1F8eLyZ5nkFWWrWScdQQvXzDgNUr3X3QpnOL/Iq7sZCET6nRM2Me1Dg80iDLpCmt9NoUJJ5Cou/mgcktVGFuXiZUe1nC1/MfTw8Mvsix92AIy4fcFGHvR0xxMwhkfe9yCgn+REEC6Qzw6/eMZvT9SAbddTFZ0+4Vz0HS4rxvSvol2K91FT/D3e3C8+PGzFFHSapsM3zMZUB+598liQvtBoOOPSfolGCnCXoIjhGGGUQvvqYDnFY5CC4VgdWm6FHQ9DZdDPUrxqEF3F/Ekafe1srDwzOXs3UAeaNe5j96/9Z9sEWb8oGLEhTgcCNvbJOOr0rMfYymQx8OqaO020PHOJch5kXTGCEz32mAj57II5eaDNg4mAjp2untSX79RzHqMQGL8NGsx/+2VYTd8yYFwBN4zooBVHGy0ftkvWzGhKaB2AiJ/31YP1mTnyW75o7UvJd0vpTeFWah1Pn/0/Mz3S8Q4pRlK6Im3cU4ieICji/W8x54wmzs0VPDiQ7nlFt2iqGfjqjF9I3nRY7QWxOnWma17oRmGODvRNz+Du4JfN679s2cTG5rFGVzNEs64nKK0n/eoLmoSJAYaEcrD8OiJzOseGiFrV0NceHxaOMEpc3NrVkVk+pcBAZlHG4Sf+PAFx26VQYX4YczSlQS4BUlGTOT69dXDvTYdENxLPyMOEcyvD6Z90rciFWW8H1zhgFBsWZ
 7yXTdAqc
 bCOoZI9jaU/oltS7bcrCflAKFvlFfibNukQDWPkqACfDxABeDN7D7RdI9Re3zaxDg3X8AGnpJcqgeP2HriH70xqgC2vGY80KTbulyhWUmG4OUd4AkGVQYwR7keHn3x81/6/yicFF9vR4jFjtu4W6zG1Ic/TsufffMeB+tXKgbC4VsGmFYNUKssLfJ+wgiDA6PLEvTV/Y+v+Fqa2eEYnCK8hJx65oRLphq6W3XjMqDQfJ5qomdkNpmQ2bCUNHkViUKvcFWqMQx97qGiGW8nWIh9cq2B39eP0mLeC6nLin6T3fuPNd2VEdpA0NSC4P+1qAw7ug8k2MXOpyNBcwJ1/cGyTpR5aAOit0O6Fb2Jzb8G2mRCmf0uCWYAI4o4HBJEvmw/rKnRdOY2dLWhsW/w6WihezK9YqfYWxP16c/eS4DsjNlbmSWNCQ2AniHs0z3NAa+qbti9RNp4apZje7fiJKECZpD16WlAsqFeizQ3iB1XgEfJRSLuNWPMzceuMM7Wc6XfXdW07MJ9CTRCueqhY/hv3bLbFVgachjhqT4agrKfYsIsg+s+brE1z6vniaha+6rIbnZAhkPbe9ix9vdbEOAJKAMMbBO8qFgzYijgD2h806Otwaj5c3irV8YsZK+H/e7X5sZLmjSCtgA2cZa1x3wKbS+tODvtKeFpLRl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 10:32=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.
>
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
>
> insert_pmd() and insert_pud() have issues with this as they both assume
> that, if the page table entry being populated is not empty, it must be a
> present huge entry.
>
> This is problematic as if it is a write fault, it compares its PFN agains=
t
> the one being inserted, warning if they differ, on the assumption that th=
e
> entry is a huge leaf.
>
> Since the entry may be a page table, this is invalid and can result in
> spurious warnings.
>
> Equally, the entry might be non-present. Nothing can install such an entr=
y
> in the VMAs that reach this code today, but there is no reason to rely up=
on
> that.
>
> Therefore only examine the PFN if the entry is both present and huge, and
> otherwise simply return VM_FAULT_NOPAGE so the fault is retried and handl=
ed
> at the appropriate level.
>
> This is what already happens for a read fault, for which the existing ent=
ry
> is not examined at all.
>
> Target the commit which introduced the first driver which both mixes faul=
t
> orders and passes the write flag for the fix (since this commit, both
> drm_gem_shmem and panthor are prey to this issue).
>
> Reported-by: Eliav Farber <farbere@amazon.com>
> Closes: https://lore.kernel.org/all/20261112051440.16140-4-farbere@amazon=
.com/
> Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>

