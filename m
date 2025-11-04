Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6C16CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 12:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104338E0135; Tue,  4 Nov 2025 07:24:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4B38E0124; Tue,  4 Nov 2025 07:24:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5D38E0135; Tue,  4 Nov 2025 07:23:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DAFCE8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:23:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7224B140531
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:23:59 +0000 (UTC)
X-FDA: 84072841398.03.AF46EA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id ADAAA2000B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:23:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K9Fi45Ya;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762259037; a=rsa-sha256;
	cv=none;
	b=XeZXFiupCz8w9Cqxf/oCyJSJdMap4ZMkWZBd2Ld7ww6N7dQGIZF2c6TvhZpv/gxCIWKOi0
	UdOc1+JW1tlgdOiIu/Dbt6yvHQt6qJcY7LysshcSYXwvkfWMpcHC8lEY9LXIJ1vRc19jDT
	1IGDJuiBYPrOi2AylErmTL/Jyuq51vU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K9Fi45Ya;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762259037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6P3uoQL4uWs+t5G+p0taETLOYUGgok1YeVz+E2jRpg=;
	b=pZQXUB/HuS+cahGjJd/hABSabcWX8O1QFort8mkzIhvMo1MaG4MrzvupIGiO9u+BscGEvA
	eMRaNC0qwyq1bcGxEL+zJxTKizSTbwT5mnG/3qk1OdCJBzIzxrGjX619djygKIn6jjgeWp
	7LVDkpMrxLejH+ZnW/xcFkJm6gdWhhg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60FCF44324;
	Tue,  4 Nov 2025 12:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9585C4CEF7;
	Tue,  4 Nov 2025 12:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762259036;
	bh=OaulnFfIv9hYj/nauRuDYbAuQXPylBEP9GcGHpiUvAk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K9Fi45YagBaVytfPhJw99wYzHfVNhv98n74R+fFiWU8QxYsDvSsWBlIN6UqHzHzDM
	 EgagJn9KmmEi3ffbOXmcBMdPe+pwuq0fNlDsVtL3DxfEpg3PzU7uT6lUGHhQ4wbX+N
	 b2Ou5E1SOeTf7/myN14KvVyiJtH9HLgtOmmbUInr6fjXIq97H4IetxHdkF4I2tt5dN
	 3x/Uq3dQdVTZR+i6g01hAO0DkOSj6LnZuGrpJohlethDz4iBq2jV0w8SR+mlavFOPl
	 BhQTVhIVgdWIVRifdPNl83Upz+rjhgt6glK2tfydNYBic9UqNyuxaKKo4uhajRvBTq
	 uiQSXFDi0MWGA==
Message-ID: <52e064b1-819a-47b3-9f4e-7ab0890841e7@kernel.org>
Date: Tue, 4 Nov 2025 13:23:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
To: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>,
 Vlastimil Babka <vbabka@suse.cz>, Axel Rasmussen <axelrasmussen@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 James Houghton <jthoughton@google.com>, Hugh Dickins <hughd@google.com>,
 Michal Hocko <mhocko@suse.com>, Ujwal Kundur <ujwal.kundur@gmail.com>,
 Oscar Salvador <osalvador@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
References: <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local> <aQPCwFZqNd_ZlZ0S@x1.local>
 <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
 <aQPU-tyo_w68cnKK@x1.local> <7768bbb5-f060-45f7-b584-95bd73c47146@kernel.org>
 <aQkUwbx7Z4q1qcSB@x1.local> <5f128cbf-7210-42d9-aca1-0a5ed20928c2@kernel.org>
 <aQmplrpNjvCVjWb_@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aQmplrpNjvCVjWb_@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADAAA2000B
X-Stat-Signature: gfi7turewaxu36koh4hq1bp5with3rdp
X-HE-Tag: 1762259037-921400
X-HE-Meta: U2FsdGVkX1/7zT3YMF5BxZ73G1XS24CgdgzKP4aLqZH+cfgsRmhHHXa3i4tXZtgYpLU1WiLKtVHDrr1dgO3LqMMlBUUmxwuBmRPjRfRIrCHoApqGsUFJuSKK3XhY2P7TiMhQd9EIAhEg2G9cxVFOfFO9ISMDVxy7xDDzI+pezTJaqKMk0owGvnaUJArEK79SdA7BB2kgYpAJUN5guFY/M9RH65kRvvVqZ6uNiMsQaA0qXPpBkdUQC+gsq5zHK4IU4tdkUSiDkHTgUdPuWVkckvbu9eWnUB4c1YrgYztnDWp+YfSanuAXSD+chj+Y5VzqL9gKh6KUn0CUKYSdhBP6s7w7GzvnWanxFbzSKzL1GHtPzeKcB1CdiJFzoj+p4W5xQgEP3lQ48p0AME/aSCNq16paWyX+U6sHJu77XLQkiQ/R+7Vw1PVdW8u9TUZ3TusdR6BYpFYm2vJzRywm3b/SYzbYiJ0covUbCVd7mpWdD1Mqnkq5EZAZ3383WMPZHd5HpyJG6vsPtQdZgIcMqH5Yic/+iOLMXmFEpKlU7bYFGNvAlzkMOk43O4WwCf1kc4I7vD7QLTv+ZTw4tcVJUT1rn53R1diJaxQqUd15PdbO1+2IQT25+lkMCKGOdLDPHaYKuxXSiOt8Yhnev05xXaOJs68cEObfCGICpyGI5fi1VsBK6LWuXq1AF0YQTZw39S91o7tDZ3scHZ+0urhZgS+xsMnQyvAw/7nJrMBDatAy66gKu/TIo1ShFnIXDT282jQGWBHnC5B+0G/Ct2+9h2Byy4dB5NG/hz3jOtvpMru8i/vPvPRKCYFY2p1SaM2sS9UoX/PUiPucmrXE7JnYHLu72ZrOFKFKj6tTydeDxTO65O4easAqVc3CeWiZsUR49qkpBXd+UcN7ZFMwDa0TB6U/2svJzWBOUCb2AqVdbGM5KVR7XmaqJuGpjZkzpFYYUkIjp2In8r2UQ18XJEK2WM2
 FwgZDDZi
 wqF3M11/k/T7ucFsGZH0vz9TMWI/riDclJ7YR0rF73RSZ5/fkrVH8GblViaqebc2do8OtKcgYDuHm/WC/6Mkomy4XPp09m/b1+mvduErLaCpbz6SWwDEksIvng36HFEfpT9pvP3aWAjjxz7rz0fTHcnjGEY1WnW9b88mUGkQf1frDzGXKyZptH9W7CJ91xpkWZgOCI/bfUq88MpEbjWpJNJJ/pro/hGWKT7TP99G+EQYrDuWmyWPGRwmHs5bGZiKBL7pPgNnDy0XME4L1EwMlJK3ZIxnNLVkCAuq3nIfL8NdQZONmzi1h42BmGvf1McSDJ6Ngm+4xUeEMcggL0NrfZu0Z9HEPMg9zj2Fy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.11.25 08:21, Mike Rapoport wrote:
> On Mon, Nov 03, 2025 at 10:27:05PM +0100, David Hildenbrand (Red Hat) wrote:
>>
>> And maybe that's the main problem here: Liam talks about general uffd
>> cleanups while you are focused on supporting guest_memfd minor mode "as
>> simple as possible" (as you write below).
> 
> Hijacking for the technical part for a moment ;-)

What?! That's crazy :P

> 
> It seems that "as simple as possible" can even avoid data members in struct
> vm_uffd_ops, e.g something along these lines:

Right, that's certainly even more "minimal".

In the end I agree with previous assessment that the original series is 
not completely a "modulize memory types".

If we want to make it easier for guest_memfd to support 
MFILL_ATOMIC_CONTINUE, then maybe we should focus on that, and only 
that, for the time being to make progress.

-- 
Cheers

David

