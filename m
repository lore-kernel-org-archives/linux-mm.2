Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2079DC54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F03E36B0092; Thu, 30 Jul 2026 02:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB806B0093; Thu, 30 Jul 2026 02:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E19426B0095; Thu, 30 Jul 2026 02:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3F2C6B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:33:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 615F6A0671
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:33:05 +0000 (UTC)
X-FDA: 85044475530.29.61D6F74
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8025E8000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:33:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fBCvtInM;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785393183;
	b=csvTHIBe3LDmaIN6Z/eFMmkwjR1iuhc8BEDZJ8ljsI7jgHw0KJSQ1wfwewpQKQ9JqKfNDL
	5JU4SiokEsIjTgs9DiD9jxSY045YTR2Fxh/mIqcUUN6nCJPJvqD0kTFmGv2BikSeC0KNAE
	3jMeinDJpEGXa0LmqWbs21vjx3uhVc4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fBCvtInM;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785393183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bSQdFbtMw22wegisDIIs9GXGwF8lm4tP2s7WAQxucNU=;
	b=woP/O51JaZ4kIuH7wJku7a2jt4fam1hLdD73o/eAqI52jaL9tilcx3EXC6a92F6iLv4kKE
	y/YpYKL4W3tJRYWD+ASZ5U3+lXBqANWnQKVatETP/f4DzIS6HhhuAPMqBmVfUmaFmBSBuF
	o5EL1rptmEAieVZmjT5zcdmO4TIMEvA=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-908239232adso2565486d6.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785393183; x=1785997983; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bSQdFbtMw22wegisDIIs9GXGwF8lm4tP2s7WAQxucNU=;
        b=fBCvtInMjJWuHoicK5RW80qxFVOq3gUmhrIJyh9MTWJhqhjLTrEzzuIRKRiS2VPHdq
         r5LHqIPsZKVh0FweSboZu/oV49IHq9YVWOvPsJsSjHdhMGiKLrr0ldGFfjK9jN/xunrb
         v0j/BHLHmmK61MMVEZmxxm/X1zuWT/kcW1e9Ay+DmZ2DTDj8qF++Ll3rB+Ba4h143MMv
         pY7Vo5SpZmNScgWUp9pyMehmv/avY+kuow2LLe18hWBnLv1Lg1OPkLRRlkwx80KYT7Xy
         VGSStlkLFzQrG/CLCcK09hsnCNRBwo3FIylTEi0TrgcFhGdc82zKu5QTLK3gncgnJP6+
         yCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785393183; x=1785997983;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bSQdFbtMw22wegisDIIs9GXGwF8lm4tP2s7WAQxucNU=;
        b=O6jaUutFydfjPCPzwj3izJh8hu8F5DwrhHvHyHuoyNKpU8JnxMHihhCIXjggF9YpV7
         Yl6ZPxyLTZkS5RuPxGajz5bsSybx/ZbrotxE2buTOwNlpoSlkAKzdsTmh3AZWsXa1YLI
         XXUZHyANMI6yWzCC9YvaOx4BHHPGRQer97wunhIAdMY2PiSiOAjvEYCp85uUZbu2j5ro
         Wws65BA7CUgoloBDs9sIcNFenFpTXxSSIqs3WHOoecsxSOdG81w0sCos0r2tTCP1a4HB
         hrMyimyfyzKogKUmNtcKnIcxbrouYmItnaeLz8nwcxGlc6G0IEvXAV+O74/nJL2bPwGC
         gD7Q==
X-Forwarded-Encrypted: i=1; AHgh+RrJNvzVHAD7ZCYqcVQ7nSD3wBoLU9TXdznG12zaIZfuf1iaEU7CJYyB1uD3h/VmpP+UeXNXGl+0Zw==@kvack.org
X-Gm-Message-State: AOJu0Yx8aJTz2PoVQe9srVYA+s7HPHy7xuNt/gH8UNkbEfhheJT5IX4b
	BKvlDySlgtSOfV6DSBB2hIbIesGq32Fhk6R5CrsVnhDplYEmMw6yf2kdDr4v7AajQno=
X-Gm-Gg: AR+sD11tChJxoF/NmA19b3v0FReS5dNkzztwpQRANBWTGxtb5BdlOxCyQMnldNI6qNP
	bxukfbqC5DBQ6sFoMBVq8hxVP625HrvBIiziOFGECiVbevvNWQC8+sAe2uhefDrFQEDc+bPGrfC
	BU8431l7FHFodGXqDTvcZXXN7z8xmkpONgDN9dsPXZQkcXqK/8g1XcKcc3FO9XnxN5bupFs2Re7
	00+nN+yBp6KrmuyTayBz23CL/C/Fg1KE6RrDh83zDyengIXSdH0PntCseWjt+X+llVE3fk5r+eT
	tQXERkV3J3We4cTYBxklRz2qfFrpsjyjYb02scGwTTXah3G8Eee8YebwSDR2+SVeFmsf0nk1PP0
	C4i54M5v7NFNtA8VnFk87IG9lih297G8n1D9TuZlMKxo7PBFEB1doc29PMCmWez6QDZEdsqDU7l
	FihLkIgYAbeJ3m1JFb9JEMJcQbyWplt/tATNN1yEEPcFZ4u2msQW3HkXGlyKBTBK85d6JSLATHN
	3sPaOxWQRf/fqc0MJBR6gtijXWEWzGbG+VBYK2/ZMy6MSzYMloPmI4=
X-Received: by 2002:a05:6214:4b03:b0:907:8960:fb59 with SMTP id 6a1803df08f44-908351168b4mr10279196d6.34.1785393182683;
        Wed, 29 Jul 2026 23:33:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908323e7697sm10555086d6.25.2026.07.29.23.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:33:01 -0700 (PDT)
Date: Thu, 30 Jul 2026 02:32:59 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 04/15] mm: update print_bad_page_map() to show
 anonymous page index
Message-ID: <amrvgjPNfKqWPUU0@gourry-fedora-PF4VCD3F>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-4-e8ecfefea812@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-4-e8ecfefea812@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8025E8000E
X-Stat-Signature: td57xbsnjjj13xefs9pondigm5mm1czz
X-Rspam-User: 
X-HE-Tag: 1785393183-887628
X-HE-Meta: U2FsdGVkX1/KQYNU2mz5U9gPFEDlJQB/nTyz322F+QtrxA1tLKNOXC/qvm7Kti9TpFodY9+lCsbvQYSm2BGw50aaD+jOCMvPYPp+pbACqXtdG6k7asM8W449zTs96Hd6J11f2OxuHxln4KByzcfCkVwI8qqOYnM1j5kvUdjbnHG9mQodIfnUMrFRupsb6FgkcKxWcP/Q7eTIYufDUsNFV9fPZYs5LihqXkOaGTMhj8FJXhnRFeLJyPzmaeFLHcE5h9DbjnxJXiTcE7AMvgieJRB9Jzj7og+KDWD94gNQes4W+dbomX89nRVpiUy9hiEn3qk6atvwRufzABPVT5t1PGg1nRaEGELQf5AonRt2cHBER7Qqbk2d0IW9VzjtgtNUcGvDL46IicYiyTNoVXloPfG7++uM8VQhZbNgxGCXLd88DkoKYm1V4CTCA58BtToE+BJHmyhR9ZCW1eU55lLf3cnLSXQM/uuXUfvwnvSFjC5/uD5xFNVjyrhNCysCul7QunjwVGyPwlpdgLKaaYjPtfVLlzzfVznBTe9BP5m2GlJa3A/vgfeKmHZpQYa5SJUhTHxCwoy5c5FF8LL/Jp3LFeHLUVsBfZHmTICuqMGhttGZnD0WbHsLaIg0McRzKpp6ywYkjBD8NLO4X3TubZxOpdWXv8F3BuEPeMZkReP641qB80AR46N0yELiYrNfGwRvTuTk5oQt7oFL2umHcUSgyXbHKhfKnnUwQNHX0nIOHDLHHo6dN2vZ17B5zBxkvjXFyNBTo9FfJP4bEYiqKGt2Yn8XrwK/MJ36GitDq8JMCFq0TChZ76p1Xyton0CguTnY2v/9td44noQfp3iY7qH5MA/dCuIZClIb3C6OWOhZsF1f+k1OyNYl09DSBwM7KEtj27JIXEh1QkpXSvJ5og0pFOn1tUKMeRVdyG+5Mh+TG1peuoALaqop3v76JiCcbwU4UFPvdm7ISFHxhvpP+/1
 Tt6tbd6+
 J8+YNuRoymmtsHkiFMGORUElkG92tLXiD5Aiw1N5MxTNbCyJxNfvESOj9k916b1YUIr/x+9Nw8tQFYH9Pq7jNqSFETpgL+TojJvEjhHaFXUAiLbG7KC97IeCjzymCJvZXyR0DTE1MK53CNR1ZHOroWUdBvJ+oLlqpPUOZey3yjIvLwAkDlQJ1psWb+q6q4AMQal9N0aYswsEl0w7XbZAOYjMS6UCVFmxbyvA6SSuwgn6Mc3Ibug92DYsBW2S4HqpH6J7G+yYavhIrlyMrEwNItI6t/O76E3GeR1+xhdv6zVZqsz9mR/6p0W7uOjDfGUkdfh1J1nhlNpIVsWxRsnlRu2Yq3onRweD3FwpLZHGJhPcjbrIAZmt+91ohcD9xVnIExA7oDqiwQGnD51mFBYpC/cVYjULtadb3FMfeFinsIWBtBJWmxWLUBSr7j+wwFYs3zejOXWxZwOkxRvw6lR8+nWYuW67f5EhyGfhL6hYzwOTOy6kwIoRWAseCXlHoUS3EEGwxwsFjxtNs4dgFJCTH8rQUfjoZmUTd8wbF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 05:48:39PM +0100, Lorenzo Stoakes (ARM) wrote:
> This is potentially useful debugging information and matches the existing
> page offset provided.
> 
> Use the raw __linear_anon_page_index() function so as to always output this
> value regardless of whether the mapping is file-backed or not.
> 

Begs the question whether we should mark the value based on whether
it is file backed or not, but i suppose you can gleen that from the
other printed values (anon_mem, mapping, vm_ops, etc).

> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


