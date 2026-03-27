Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09D5310ED679
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA4B6B0092; Fri, 27 Mar 2026 09:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C22F6B0095; Fri, 27 Mar 2026 09:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8156B0096; Fri, 27 Mar 2026 09:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5076B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:58:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46849E1801
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:58:22 +0000 (UTC)
X-FDA: 84591997644.12.00051A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 91A191C0018
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:58:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SWvmhHE9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774619900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rV7qUqCmt9pMEfSsapby4O1NuRc/CuDUYfIgjrOR9R4=;
	b=n4qWi+xoQqbXlLC8/94RhuX9i0QHqobHvDiGfKbv3cgDyucTl5zZyVXhqfLcLg9cTVM2Xr
	OVW5eK6dUttO2q0do5lm98RVX3rTJC5XvcvHMBujc4lE2wH/VG4fc1F1QDFg+8CKn9vcK0
	VAfPUPVp9UBLJiB8WH3O6T1nR3MRsuA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774619900; a=rsa-sha256;
	cv=none;
	b=O69SovubQaJi9Q6FNYdRsYuPFWKDOMvvqccLzTTibvuarnPT9yB0Q5pXke0ALq0BqUHFd0
	LLOMbahu/pp/ig+d/hCMEGA8etrq96hXCMi9AjFTAjH1A0p8nYZe5+C0cGXEXsX3n6MZYi
	Asr5o6hLBdxS0Ciu8DQJrrTPAcDSBhc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SWvmhHE9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AFC360132;
	Fri, 27 Mar 2026 13:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D735C19423;
	Fri, 27 Mar 2026 13:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774619899;
	bh=VqACtXhfTYZCQGZ04hZLNOj+ApxLBRqLokDeDdIuV6Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SWvmhHE9QgoG7BeeIXiy8S/MxDrH6bLIFaNzJG3Tn0p2MnG/Io5/CWnOCyGrz2aLW
	 geze3jKXXes3f/fa44jBQySmHCda1h0nV0OAoKNw+OX3CWBVdREOK48PnFPgHvmTVf
	 qBqFCuR9AczmRrJNvdALxpqkDpfH7ZqC1oGWWP+3omn+BFX0U/I15Q7KJqWFWEbUIX
	 9qaiy1dpsnmCWXcdijGqoWkc2BrZqIK5PcpUi2Jrdb4NvRLGVkrEueTpTnzLJIUSlV
	 4uQpwJcszdyqiYrXKTT+BtUEbjtX6/zW00+pcfgM6YcYoQvk+eofuhty6uZaim/ZfS
	 GTx/hySbDFbCA==
Message-ID: <b098fce7-be16-479e-b9a4-36f0ad71d242@kernel.org>
Date: Fri, 27 Mar 2026 14:58:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
 <aaea8ce1-eac6-49d6-8c85-7361977b9a9f@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaea8ce1-eac6-49d6-8c85-7361977b9a9f@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 91A191C0018
X-Stat-Signature: pzbzh84osm45ufsx99iocpfzmog56grb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774619900-826415
X-HE-Meta: U2FsdGVkX18154e69N042Bg/gq6kT/bm4ZTtUdpdqdT0TaUXrO+XRpRUu1l2yN33PgUrYj635B+cL+5pTCYH++9QMdSynLCs0kRMDUloj2M87wB9jqD1lzmf9PH85WNJSNtaqHUKaX7m01hCKopJl98gh9x2u8XZfZRnb2m0+duhCQGZvbtr3dHp7XBnZnGGyTb/yU/Zf8bCfLNqPKrEYoAw0fxp8DOOgt5rfep8Sb64ZEhdk25tUhKP7k8IYBq0O25osV2w55UND1SFxnxUjUxVTTzo5J4IPcAy5vfpNHecIXZtSCBBk1N6zTc2ef4KA+c0Z22OC09zO6H4k3Mwcd66Mpaf4wC0zRlCmMio5fsSv1zjP4ZfaThgS/HmfRTlRMgFt2NBkR50hPq1+9Na10FRefXGhGirEO9qjVaspctVkODPZFBKZCBfjxJKSoPIe8iz1DHbPf+CBFhVCV+MpQU0MXr7QXeP+EX/o3UKwTLl7Y8AWFFb96gAjuDtqvLhEbHONGO6UUU3v1VIcrw05NSD+Z4Ly0xJK7AKp/KUkk6T0N4dZAzv/MmezTOHz05+kDl2aVdufTl6GxUN8zPCjB31oyimEFyoz4Erw9cJRfNNvO0sW9fKTBo9Z4U3ReVRnA8tXgx/D5D5n2Q/jiXFXPHHdUrb9xorKdjfJHe+z6Fk8WDubecmx8Eto/Gzwvk898ee79fCUrSH3/44ey1WxpgsSQcGBs8hrgNGkfdaUSOQdwpRflY+4M5djvE0uXtWqsf5mEKQThWW2imquizsp34hysaYOXJ17Am8hcdFIYeNjYduL3AZMmYPj8znpeLjLQ9z1JVzSpFXnRzcQpJv56KyRU+tl8Ros2COrmPcXaUB5Pea41P/5iYzWFHt59bclBo8DMxdyw4bFTZPd40h5W1NQgxk9zM8daW+fkWCCnfu8JT4t9XAkhNQ+reP+ir/EQQrqOQl57ez0HGu2Yj
 XSzYywYr
 EaSb0kQxLUUNsgJoATiG7AIQbQUlFD1JR0CTBK97THZxdklaZ3zIxgYMwUDIvN8n4xglpx9NOoU2iyn/j1jdQ464+9OKJ9nWVtme70M4nlKrspdvmSFhgmw0aHzWh4TrdHseXvr1fxzDC4+Y59oJzjOUdOMPGk5YfQqdD87NTvbtRSBlnK0KCffJjQxgEv+Y+JdyH9SxmkMb4v6sPsKNjI9SAo2AhIKyBtSPWS9dIKWt9Re6cn2sr4S9BBNOm19olWIDuEqG0BOtnVKS2YbRPjs3GUocHv1xte9W/MBPIB3ZmClyv3RtYJTgOvehdq9M7TAJ1hjVcToRuE7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 13:23, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 26, 2026 at 09:42:48PM -0400, Zi Yan wrote:
>> They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
>> large folio support, so that read-only THPs created in these FSes are not
>> seen by the FSes when the underlying fd becomes writable. Now read-only PMD
>> THPs only appear in a FS with large folio support and the supported orders
>> include PMD_ORDRE.
> 
> Typo: PMD_ORDRE -> PMD_ORDER
> 
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
> 
> This looks obviously-correct since this stuff wouldn't have been invoked for
> large folio file systems before + they already had to handle it separately, and
> this function is only tied to CONFIG_READ_ONLY_THP_FOR_FS (+ a quick grep
> suggests you didn't miss anything), so:

There could now be a race between collapsing and the file getting opened
r/w.

Are we sure that all code can really deal with that?

IOW, "they already had to handle it separately" -- is that true?
khugepaged would have never collapse in writable files, so I wonder if
all code paths are prepared for that.

-- 
Cheers,

David

