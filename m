Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664D810F284C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6D956B0095; Fri, 27 Mar 2026 12:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44DC6B0096; Fri, 27 Mar 2026 12:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982846B0098; Fri, 27 Mar 2026 12:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 867976B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:14:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D1F116090E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:14:58 +0000 (UTC)
X-FDA: 84592341876.30.10884D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6850C1A0008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:14:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZYqHZHqo;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d12OfPYOY1zhSu6WUZypvyObYOsxUhXXyZg3eNDRHd0=;
	b=chIw5nHaXIsP1zeMvJRZNxvB2xTmEDv52VcqeBebDcADlYnW1LYgQhhWoV3mmdaDtm1WqD
	JbR5sqKkAUxmYBwk7rrZ1h1j5YiCTluWvoq4pgANk9aJd2bz2sDSqMbL7qNdMErJM8MvSi
	7/68jZbbaUf2Yu/dSV4fWdpc0AC7iLU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZYqHZHqo;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628096; a=rsa-sha256;
	cv=none;
	b=eUBaq333pjxX90zvaPKsvMsHqf8B0IxIamOTYKKF/a+X06kAcHe/eTOTRnDYRIEAfqfMCj
	Eg6bxU8HAGQ46rQbIhEl303TcgwNH+UY8chET4JTgUiGFAgq6uvBSv6fin0LboOICSPbOZ
	prEAYPN8tu/RFB2aVrsl6fPP8NzC1M8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E90F42A12;
	Fri, 27 Mar 2026 16:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C0FC2BCB0;
	Fri, 27 Mar 2026 16:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774628095;
	bh=zXNUom4JcbcJe5P17bW0VcYg3BF2y3vbuxuAyWXA2Yk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZYqHZHqoR6y2KHbwdL3I4ZDGCUvKQVvkCNilvo9VFfK+sdEwwTjvdXUng8CkB7/R0
	 y2A0V03w7X6WjHqqd/kgfuhGJBSA3J/q3PjhoVwq2zkB98Ka8b6A5oXju/bsSPygDJ
	 PKUxVg2T7fMjcYFKT6FpqBH5sNByY0nEl3Z5ay7vWhaILcHJEXiefoudbSUOHxvR3A
	 T0ovJe0NHcSU3WmsVuhpWMI9QpGMOnSw7wFCAKv87aJ4oQX4wzMlN60Bslfs6nVHHC
	 DqLMrUA6eTo1ei9iwueDiBgHjCJE9VKB30Fz4xqvTB8jm0kztjIvo6g8oQxdV5olSM
	 t6qw8eZhk8WPg==
Date: Fri, 27 Mar 2026 16:14:47 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <be4edc58-d343-4db1-b861-31c98089b3dd@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
 <075A4C69-B386-4557-BDAA-4038EB36370D@nvidia.com>
 <14af57ba-09bc-40ff-812a-b41dfb78a03c@lucifer.local>
 <59A91369-9BCB-4545-AEF8-083B52998CC3@nvidia.com>
 <10b04dc8-e155-4a31-84b6-17b302e65c7c@lucifer.local>
 <52CACB9A-A782-4D11-8B6F-66DA8D345C78@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52CACB9A-A782-4D11-8B6F-66DA8D345C78@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6850C1A0008
X-Stat-Signature: 1agn18kmsn7drz97nwyqpwyh5rwysj1r
X-Rspam-User: 
X-HE-Tag: 1774628096-118869
X-HE-Meta: U2FsdGVkX19jlimPgGXZTkefsWMsrOyghKK3Oq5mXq92vI6G7VtRxkqPIwfM1iM7GiGPNyDyYhWuN06VYsCM5jgLE/oEGoVB+Wjv4Z64w+t08qwOgljAZzKXJYUIK/PmrbrNgk9vyFaLb58g+DRr5tH0guPfSaBjIe6/3SMgz0MTXf7cIBV3iHDCU3sLKEJn+kaKUBvdsfBWsRpkVZZ6seX8q8xAdxBQZRQ1DLLW+opcm9QTkaKGiqizbhJsw99vlgcQNJ75aurK+pUGjjeUAEfacG3jwn2fnDa4yYASIbut8mQzFOsFdF5biQmrR4PYI73zkwzq1WOiExozs5LekP7qgCvOL26GnBHn4sLxMECQdENo/K+JY6ZTUYhhTAZU0n61sfNI3UhSPPJHjEArt36NHypVRzSZzz4dYcLLE7UDkAaxJCAdITqjickSfdZGQ0M7Pppe+71Oem8Zt3qCIVFl9xXJHD/mP3kfKjkKgpG/fcM0mCCTV2WLI/baHNpyWy0qf+3uMPYEWCKdB0cQlQfd8hq+j5tO830cjagZeCYW3eaCcD6dcJMlgT3Tn2FJsp9iQSNObB8UDZc9ukLXq1PpoYMOcFy+pc8lmxEIXNcDtD78S5o2FvqXpo0CJ4WBwYQYmyXbylQ0DjVGyUbIgffS+ie155jR4+EmDwMyJxzZamh3rQ1QC5m5etr+EyV4ZLEwILKdochoC6OuwSGNo7sb1FKrXlzNh/3mOmfAbuxhW9rxX5S09oU8fZj9t9Z7UqG3GY0XlMMeWZ7PtBVhOaMr9+hW3OpfT246fP8MkmHnbsdo+QJRG0fHysXvXo5BmulNBwp9FXvLVtuALIku7YTiGSnadPjd60K5mPoDEt5l9R046oEGR8fzSEe1EXmg//POkIok0R2ibyxQfUyQNzKMhISRkzBlH+Yh7O0WQcF0NrkHmdrbxtA5q5eW/g1KVV+5qDKB9qcgF/LmuR1
 wwgYcnl/
 jpendH48jviHT2fRp4h6BdAfZnBgWjh17g9ENcPH7wB5VXF5OttstgRw7qtmq2bkMtR64/VBhR5ASkZoPZjzGsSH6EjcxQwWdeSBSgD2+oPKFqcM3Aibq2ebn0wkGMdajuUrLUqEEssLEV2q4rJq92l/VkEPO4Nk1+iLIdDbRX9mEPye+3fRyvz7hLyGxV0m7r+wPfbDy5fTNUM/0TOnx+fLl7rYsoreSH+pUTDsuw6aBEQ7Ax27HHTHpPr/VdALsNHwmcs1rQXBPCLR/M1PtE1Lshdh9WOlI0jtZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 12:12:04PM -0400, Zi Yan wrote:
> On 27 Mar 2026, at 12:08, Lorenzo Stoakes (Oracle) wrote:
> > So actually:
> >
> >                        |    PF     | MADV_COLLAPSE | khugepaged |
> > 		       |-----------|---------------|------------|
> >  large folio fs        |     ✓     |       x       |      x     |
> >  READ_ONLY_THP_FOR_FS  |     x     |       ✓       |      ✓     |
> >  both!                 |     ✓     |       ✓       |      ✓     |
> >
> > (Where it's impllied it's a read-only mapping obviously for the later two
> > cases.)
> >
> > Now without READ_ONLY_THP_FOR_FS you're going to:
> >
> >                        |    PF     | MADV_COLLAPSE | khugepaged |
> > 		       |-----------|---------------|------------|
> >  large folio fs        |     ✓     |       x       |      x     |
> >  large folio + r/o     |     ✓     |       ✓       |      ✓     |
> >
> > And intentionally leaving behind the 'not large folio fs, r/o' case because
> > those file systems need to implement large folio support.
> >
> > I guess we'll regress those users but we don't care?
>
> Yes. This also motivates FSes without large folio support to add large folio
> support instead of relying on READ_ONLY_THP_FOR_FS hack.

Ack that's something I can back :)

>
> >
> > I do think all this needs to be spelled out in the commit message though as it's
> > subtle.
> >
> > Turns out this PitA config option is going to kick and scream a bit first before
> > it goes...
>
> Sure. I will shameless steal your tables. Thank you for the contribution. ;)
>

Haha good I love to spread ASCII art :)

Cheers, Lorenzo

