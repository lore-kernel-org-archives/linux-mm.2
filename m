Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9760D606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CeifOdun
Received: by kanga.kvack.org (Postfix)
	id A3D786B05BE; Wed, 28 Oct 2026 10:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15426B05BF; Wed, 28 Oct 2026 10:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905AC6B05C0; Wed, 28 Oct 2026 10:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 638266B05BE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:00:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7A341C46EC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:00:29 +0000 (UTC)
X-FDA: 85372194978.21.8389312
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 289702000F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:00:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CeifOdun;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793196028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfRxL+0TUQIipSiCQwkog2weAefiwhTq3bgpHDJnrgg=;
	b=SLHTyCFtJ1FJmuTMP9KAmfBPCNmuUVRvpD3puCFycdksb1IP49jkfyoyyNv0pwmy39QmcF
	ThII3ghO1zIm7LX0lBQACoZb92FN8Q79omq1VS3Kpj+mC194bSrBB9bxIK1y9ZR4Hx0M54
	nuKBynR60pni1eOVUAhcq9jdki5HIRs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793196028;
	b=KikWshox4WNYlTxNznHrxR+LkKbxXzIjMKMBMymu2oAuDbUOqZ0kv0EuemEUs6kQvMTa5t
	vL8nq8MqSWV67SJ5wxPF4ko9F34PskQptr8QdxD5FCbwy/WcJ8xGjUuE+CW57jIe0YklY8
	rYh+Y6QT5FoX3f7Z2LnOdWX3Q7kisuw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CeifOdun;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FFCA600DA;
	Wed, 28 Oct 2026 14:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616E41F01825;
	Wed, 28 Oct 2026 14:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793196027;
	bh=DfRxL+0TUQIipSiCQwkog2weAefiwhTq3bgpHDJnrgg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CeifOdunBxMvBPkFlwwoFIB+iVH33NFCwB3NcYCocHQJsLLQ+zMo87mlc7cD131ur
	 i+khN/m0m4rdATVgt1GnI/a23VK1zaKL/q7p89wzNZwOJZ8F/u/UYDtrVRcJ5G062n
	 8FGH1tFbXpiYBjf78WvcdOTzQs5v1ak9Q5lDXlZN5A38XkaNVCQ3MQ7MpLyhVMBbbi
	 TsZHVWOj0mtpOjRsfDG/jg99mSMdMWxEI/Wt6X4B58zrdshOGmNZ5YlcgV8C2C0XnU
	 ick+PGq35J55adW9948Z5ABgHM1Wew34VEysP507bOil1XEvc5mx/s4HZRrezoQWN6
	 B812A4pNIxdzA==
Message-ID: <b0a2e3b1-9d36-4ab7-af22-359b9ec6e57a@kernel.org>
Date: Wed, 28 Oct 2026 15:00:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] mm: pass the number of PTEs to move_pte()
To: Imre Kaloz <kaloz@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Magnus Lindholm <linmag7@gmail.com>
References: <cover.1792609488.git.kaloz@kernel.org>
 <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org>
 <409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org>
 <20261027212610.6798-1-kaloz@kernel.org>
 <dfe06aef-540a-4450-88ba-300a460007b7@kernel.org>
 <20261028091631.8072-1-kaloz@kernel.org>
 <25f5cbed-9126-4870-a81e-65099155bc9d@kernel.org>
 <20261028101719.11918-1-kaloz@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261028101719.11918-1-kaloz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 289702000F
X-Stat-Signature: khpnm1joh8bwd1we6bansmijypiozec8
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793196027-503577
X-HE-Meta: U2FsdGVkX18ulRmlZuadX9A4ds349vpy9XLf8wgbrXmLIlhzg2biQB6rrUaUAxf59FROqZObybxzu/pukWSWNU0LLc51op8gfPfa8jkdEYlIiOTdtCLs9B5XeNXXZHXLzENnaKW2Ovr/UMfrngdC4Mpe6R0LwftQZ8YYb7O5DVZ8sMpes2C1+L4MbLQ96WxMUB+QSUYHVok8vaB2xqd/fnDYGpkdaSpJCTgb0GSoTLXVhUsBMVBdP9pwLbEG4YPhN49HPIItquyM+c1Li4kUUKjnYvSXweQ4nsmC+cRj9Or+FtEXcfjjZO030d0dSKZw09nChXRmmoWI4ZPG7uS7w6X66G4qj7uTC6UNi5Zm5K/CwiudUIXGCZnmpUmEWo0iIWNqn0g/TwZKhC4G6MY29yD0EaohOrSBncd1LqqgfjzVtUNnqoKA6tqZCs7SdFbU/ymd5HH6Mr8AWfC3sEZeKm0+gjDdo0rEEtUwX6pA6djKSWOWjBcgANjSAQ3DA3DdvjhuedZutFytfxdRD8GnH6qcTDRpcEThC8bQQKwHdv/zObSPapioSal3RBqFiQXy9Fkct7EqNzTu6zzFNIyTmGv/0dAyhvYEM3xVma0zkOsJ84n57rAa/x7JTkvAuPcVkmgVfZS+UFONjEYWYLYqCZpsdsqXIyd28RkH2deA/09vHslzpyJXVg5xiNTHKNbICFFn1oWitoKd3KvZU+Ny9V3i4mxz5G/mY8OBiKV5AMrI8m0HpNnPwpW5/RRlb0OXLxQyWoB3ugTihnrpKD7LH6hXWs5Dzl5o4bL58MUOH8owp4qvGRJazHHbbKajnwDj7eJk2Lvl7PA95Jah28VLj1IoDguEziGKvYgfWchS1wasNOhTJlSrY6agj+p0+8nHEpEkIg1EKwudpLv6O3805RL4lXWt1YphYRdMRJB0viI4CGRz21BZB8Q6nfeg9tqP5JeAsgJP2Q3SVCp3/Aj
 wgnaFDqd
 +IFudiXXolfzcKGzARifHxz+jGTXenyuuJDPzFIDEyZNoXVaCagwB3Cv3ahZCzMbkBycfR1wU5ANKuxDFOt2eUqarSQ9IxY6O6fESTi803KW8CCbTR72aekNW039zSHsZFSAKqPdtn/sn+pHOa/Jp39y7nK8QlEXESwhw/Kss+ovpebsxFyKgjPAAkr9R5flQrhw5jNt0b7agVpeC4FRxB/Bj685vcCTCgQAeet6SpPYzUqsaxwZy+AWdfQ1/6B9CH1vhPkvb73Y2C3brxGCF/hihdzNZr1mf0APwdTX2aYYF0VlcKIT/Z8s1/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


>>
>> Because otherwise people will push more and more for removing legacy support
>> completely, and that's not what you want, right?
> 
> Definitely not. Fair point, I was only looking at it from the sparc
> side, and keeping these platforms cheap to carry matters more than a
> few percent on reclaim. B it is, then; it's below the scissors, on top
> of 1/4-3/4. Thanks for taking the time to go through this!
> 
> Andreas, if David is happy with it, would you take it in place of 4/4?

Thanks, appreciated!

-- 
Cheers,

David

