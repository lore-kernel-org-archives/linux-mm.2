Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817F1606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IkTGmCAA
Received: by kanga.kvack.org (Postfix)
	id 9E1186B05B2; Wed, 18 Nov 2026 14:48:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969F86B05B4; Wed, 18 Nov 2026 14:48:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880546B05B5; Wed, 18 Nov 2026 14:48:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE046B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:48:36 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2AE91A0885
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:48:35 +0000 (UTC)
X-FDA: 85449276990.19.B88C39A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A0D5180007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:48:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IkTGmCAA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795031314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpVV0Wh5WoFLGZ7/rqKsEhPXGxv7oClSM+KH+MM8Q9Y=;
	b=P3d34FS4Ukdj/XIlWI/vZhY8spCuzH8C+d1adlx/oeodQdb/nqOT+6f90p2FKoxne9tiKg
	pebEU2e0KHo91Yn8/fDkw2S36vdM3erZALvzvwSQylUpRvV9Sm4ZL9A7sEU5p6Gl3KO7HM
	NDXn1fhxBcMRo08+wq1WzBK2j0OKSAI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IkTGmCAA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795031314;
	b=6OOwD3N5fYXhjwH6ds/ZZvxePCr8SAQtpOHx0c41ErYRQj1B9dZaOUiCHR1OZGdRDrBBVV
	Y3kkQEhq9K8tJzVmVpUPZEhKh7b5keSfi5HBVNoWL2Q+zfulsNrVJq1loJcbffI9WGsU7D
	5NkLoCuFsHujXKp/L2SYIuh4JIuVgOc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D097061CF9;
	Wed, 18 Nov 2026 19:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95611F000C4;
	Wed, 18 Nov 2026 19:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795031313;
	bh=tpVV0Wh5WoFLGZ7/rqKsEhPXGxv7oClSM+KH+MM8Q9Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IkTGmCAAKxevgO+sQ+K2meWp6L/aI+OlhWH+HGMM19YYkOWJfV5h0TpW0Wdi9hUS7
	 vtTRNCq70nVfxloRxfCJH+tklnj3/DccbeQz7G/MEAS4/RBQ5UK78FOob8WuVctCHq
	 J58u2SsdE0qDScMCgjJ3R1Rfr8rCdMw5oIqpx8GW6BH4xEmdSyFPk53BlBtl6XmkWI
	 6cY2DeD0ukLnU3MnlF4B6rkwMzDM8x1NzYR2UM0VdqOvLXw10CvpXg4Tx6d+GGUYGp
	 G/mnkmEAwWGeTJTzO2eWprKmJNAPdcdxShUoF8TlqugSdTSGTlgg9qElXtaaGH6Q7y
	 mkA2SeYXPzlcQ==
Message-ID: <31865531-9a2f-4ffa-8ff2-a1bed0cfd41c@kernel.org>
Date: Wed, 18 Nov 2026 20:48:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: consolidate the memory mapping entries into
 a VMA entry
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mr4p651nxsyrbfuzxgxejtfxaca818sy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3A0D5180007
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795031314-774631
X-HE-Meta: U2FsdGVkX19oH7es8H1C670rbUiY1xbDu/xyUFOAK535IiKT1kRdsvykWvqwxopoFmsF+V17NVvOeCzyZQBaWatH7wrce7EyP/J0gfnbyh2Z/RbPfO5eK8MvcBjaR8DL/8DXZedA3cfJ6tEQiO01mGilVtAe322wxNZGk9FYQLD2r9/xwaBhQaMIs3PS6SFp3gTIFJ6zAdW8HVFKRIjBuWhxJLRFhKZxEG7JmcrYdgzTGNuO5cmn+0Dd8nhpXf46QMm1HaZVTukYAC7eYfuuiF/RmgSpXS11w5o7DpGMB/NrAbOWmUQeOppoz1PU6/AXuvFYc26xp+4G9wR7CVZiRgg45UHOfnc8Cv8jP2QGwHizZbofgzWgYEol7j/eqRXezvjNQVRlNz0VcwV4y2lwppFfq4/ZJGeGOlLnQ37H2zZwPRXVGtdox1JmuehXyeqGGrGJW0O9PhrjAnjn0bOsgq81WUGkcOjRX7M7gha5Kj1ywKd4iogWtErIEWo8C6Y3XYR7hOiZoZX3WngfxSQ3HT/fov0FgXxlLcRJsFSybMVLrhSHNYf0OSelW7TRPRCUbNRGxJm6dxGBlEcnywmZ/I+yQ35lcgadQrTGQayS6WMBvwyKJde6J704tj5npH8mFCNUmMG+MR3U8Eg5qtcWCfANQcjixf1NeAR6sUUpflI0NiiSpt5w8Hxs2kt9kMOMFqyZb787iZ6mSAMLwHCFerO+5pdmEbGOAGknVBzV2n126760BBXcdeM0E7tbL5Ve0KsE9eu4f9hwrXPesm080b6qw389vEShsGv6plCbLhZmlcBmDz9D0XoAE0BhgOdEUxuGtATCGX9g4TLl77VtP7vH+sBmL3J5ZW09oC7NvCH+1GuIU2m30zhkXJdlFl8tGGfEfn4NYIOuTS3uaJ+oNlAueRKXHzcEHTQRIByFJmtnVtESgkB3zrtx+QaC+tqd67hPdILCFAdbOkCUBmg
 7E4AsNOK
 MF6AFLzhviAuI+JqOSyoJ2rluAwPVPUKYdp0muNOC1/etIUDRi2BJhoQ2vagtyKXRN5VBa0tmPc77JGqQ1j94/Q9aUY8+OwkC+vkpn7JG3mGrNA51nQVxJxadb3OVHNq3HyIZ/c8jCvuHcCJAw+fIk/27OBPKGyMZb/dAXtxqVEsrJQ4CWHJLwzUwJMwD72+r0mv66KVHY+MBK+L9xpSxG3O8NLA9oel4IvCn5SEKIxiS3B5QSNl6wJoV19CsRBI15OOQQziCMWxIv3JYRMDhPftXc8s2Dd8rdFoLop6JVvV/XsWBRCzd/DjtnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 19:22, Lorenzo Stoakes (ARM) wrote:
> Memory mapping entries were kept in three different sections in order that
> those maintaining/reviewing each distinct part would be made responsible
> for/cc'd on only those parts.
> 
> However this creates confusion as to what files belong to which component,
> so simplify things by consolidating them into one.
> 
> Expand Suren's maintainership to the entire component, as he is a trusted
> and valued member of the VMA kernel team and very much deserving of the
> position.
> 
> Additionally, drop Suren's core and misc reviewerships in order to focus
> upon VMA.
> 
> As David is receiving pull requests directly, make him a reviewer, purely
> as an administrative change.
> 
> Also specify the new tree location in preparation for the tree being
> established for next cycle, and remove the link to the not so regularly
> updated linux-mm website.
> 
> Given that, from next cycle, the tree will sit outside of Andrew's current
> process, remove his entry, also purely as an administrative change.
> 
> With that said, I'd like to take the opportunity to express gratitude for
> Andrew's huge contribution to mm, and for his being both generous and
> gracious throughout this period of change in the subsystem.
> 
> Co-developed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

