Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC6BCCAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 15:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A978E000D; Tue, 23 Sep 2025 11:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132148E0001; Tue, 23 Sep 2025 11:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047F38E000D; Tue, 23 Sep 2025 11:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E84398E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:15:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9157586210
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:15:34 +0000 (UTC)
X-FDA: 83920864188.12.39A69E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C3424A0016
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:15:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WfwQuIoy;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758640532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwnSj7p3Q/tx6VG10k8u3uv4eFovRhZeVa84Uk86YIA=;
	b=sE2u8lNo0jpJdwB3nJegrbYC6+ycs7hPXm4MDlhavA5KGzmkh03PIZrr0notJmbCm/r2IO
	Zl/da+u4fYdhSe9PTikHzKUumy0FV3B/04tS+dhHDY3E3uglyipgfsYoZ8753qsK8/Gofy
	94y3W5p3Kq5+Xkl4vKjIK/2yml5IVsA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758640532; a=rsa-sha256;
	cv=none;
	b=k7zLrmY74Q137llA4HBsbNVbHv8f3ESOgWMUfrIULFlxKb5Zk+SEQWQNVtVuZB/7zhUE+0
	cDP42fS8t+UJA1aXxxlusGNNju2Hr7QBjZYLCKHPfqsgmY1+Sfy4Krr3MolUxpVrs7vzF8
	JYbNxKizgfS7tYYAo+Id0VRcc70hIOQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WfwQuIoy;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AB31601F2;
	Tue, 23 Sep 2025 15:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949C9C4AF09;
	Tue, 23 Sep 2025 15:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758640531;
	bh=QSh2pUh6qCemOJPEa86ZyI4Hu1DhQf+P0kZsqsg4+E4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WfwQuIoy7FUqx6faIhuPoUIqzOE6FkxjxSGwCnfzNlNRBRWyHbuLdszt14KW3q06v
	 xh9pW4S6xSvgO7EjVO4CXIGgQqovowXulOceaykBo7m6gjEEjVWVWbh09TphFicJ/x
	 GD4yzCzoL1AdRGn00QOaMg+0Fwp80XhkDx1uwoptapmvqSp2fKZhHYjVi9t0rKjxeq
	 oLa/KGKJ4psee2FDbzGOES1E69folxkiveZakbuN04Gp2Q0Ar4YSNuYkE585r8AxCU
	 aBM65kY/bXl9ghP+gjfBPLEs2wCLmrupHiUzg+0qeO57HuoyiWCjpJuOTL0Xhj4pyz
	 EWrLptbKLI/Xg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9EB5AF4007D;
	Tue, 23 Sep 2025 11:15:30 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 23 Sep 2025 11:15:30 -0400
X-ME-Sender: <xms:krnSaEgNOrFhUKsirMpjz4wKIcsX3MsPAoN70VHGHEQu1h9JbOJEWQ>
    <xme:krnSaKoSppnR107HP7WHmMcqfbZf61qlgw8lSq1JybzbjM3R7u9EjUch-8zvRcJ5j
    j839AIKrZflR0thC3vKrehx8tjR4j_WL5xKMvB5XKOKn6d1_t8OeA>
X-ME-Received: <xmr:krnSaDdAaxBVhjMOWueRHBXq92Su4eeP9xreY48DUyk1Reuvespzfq9W54sZyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeiuddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhieekteelledugefhffekfffgjedtveevgffgjeeffeegvdekteetudeggefgkeen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvg
    hrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilh
    hlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:krnSaNeNNxBH9Co-ub2i2lOO_WELsoMFk5c2VBgcZ-0aXWlp4o5ErA>
    <xmx:krnSaJdGMg8WL80tZJS-67eBovd1w2IScYAdzYiOjVMkdxOpe_GPPg>
    <xmx:krnSaDo5l4z-cBqoDmakAfWPzYxHAWx3qxoNQK9VDtpaF0gxq6RThQ>
    <xmx:krnSaJzEI9JVYkyKWNz2S8lQ3OYEHVSt8sLQCWzgU9dGryfdSEdjQA>
    <xmx:krnSaJf6A-GF8T4k63smQCJksDwqgfUPzQiHl8SsO6l-LaZ1guBrrSfI>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 11:15:29 -0400 (EDT)
Date: Tue, 23 Sep 2025 16:15:27 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/6] mm/page_vma_mapped: Track if the page is mapped
 across page table boundary
Message-ID: <abawjykg7qeorfisqsvvban3qmygi4d3pggoeas3hrld5gqihe@an33ftrczceg>
References: <20250923110711.690639-1-kirill@shutemov.name>
 <20250923110711.690639-2-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923110711.690639-2-kirill@shutemov.name>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C3424A0016
X-Stat-Signature: g8cmoo7gir1wmfkuksgw9fpais6qugpj
X-Rspam-User: 
X-HE-Tag: 1758640532-17430
X-HE-Meta: U2FsdGVkX18NuhN+Vpwf+0Kd2wKOF+n7Jkz0U7GhlF6eCVoQs4rK2j/Wf/I2pEaAq7ElQ/gtAbUwprUeV32q/qCEPRTqKYxzJ727FNPLB8PSeF5euVPcfdJG9whriVnKgvA8IVvirxZXHTia0hXMvrhcSSMIi8IxLWB+l5aBoAlJGHen0y7SFZE3hzLx4fiIrr4IEJf1vp+xAQzBhi6qByO4KkAmf68TGlUP53HC27O7iXcPWuWqQwh4FDyhqUU+JJDHyym72wUZY++nE9r5U3SxjdGq3u5FqptT38oAe1XxGe2R301E35L3fh+LKdhdTDFhm38mqr+ORKUCjY05aPMFOEJ+iIjmBs20OfX+Bnxn0pxZPFZp3QT1W43ghsytxc1E2QNPcszzfpLw60qVhqb3nrP35Y/K8KhqAomxuDhnydbcPfYyF1myOtNttO4ugxTeIigSdB95F2Uf9c/IfVjyTOlkLjsyaNpwJiGCb/9o+53urId/pPeNEcWIgrAZcpUqn4OIlzcJgX16aFyMEMq6DMNtqj+KNxUxrjCGTk+PV8VccbnQ75IeKkKvRAb6GTgLOJOcW18yEo//LZBXI9gyo4RXnnE8kCCXX3rXJOEg/tcebySU2cBHvEtAhrBzpKx1h1WmwUIijaWEKNr5Y0lcPR3uRT8LyLwWUjC37FO1QaLcVd2Sp/WEFtgdJ7+zlLzcb4hkoHRY5OXOhn0/4cmbkapzQ2JE4m1eNzFlhW8acueH3I7l7MoJRWej56WwQeNrfWRGqwyXzR/KVM1nf9/PfWmOBpgrQwQ+Ey2Nhj8ED9cfO0kXqPY9hBudMRR3PC7YIj8bPXdLizjJwkSDEBEmyVctJoPj4R+zqC4PT+VLM6jRrRGnw/wBebHf7ArQFDnCllfPaC8edF4lRNNZVzazwBLXZoA4iERml4n09p8CamyEC1JRmKqK2gXFeJCTIdD11xi5nGBFxQq419b
 xPykBFkV
 q5nu6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 12:07:06PM +0100, Kiryl Shutsemau wrote:
> +#define PVMW_PGTABLE_CROSSSED	(1 << 16)

I managed to spell CROSSED with three 'S' all over the patchset :-]

I don't want to spam with new revision.

The fixed version is here:

https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git large_folio_mlock

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

