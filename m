Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA330CCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560398E0015; Tue, 21 Oct 2025 08:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5376C8E0002; Tue, 21 Oct 2025 08:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44DCF8E0015; Tue, 21 Oct 2025 08:26:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 340C58E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:26:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE7B7C04AC
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:26:07 +0000 (UTC)
X-FDA: 84022043574.20.F7E6E0F
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf18.hostedemail.com (Postfix) with ESMTP id D30AF1C000C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:26:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R 81bSYb";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=W1VeU2RJ;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761049565; a=rsa-sha256;
	cv=none;
	b=3C0bDbf9c/A6zwMoMxO5BAL0C3uDeYZxoCfBKvqeyMiXPdbQLQaB54R94MSKLCruhfnonk
	80ZE4AdkWx+HgGSnJNkv5GCHevVzK1B66RWDK3r5S3BhyK+es6RZ7+6UIMIj1UFrkrpZD6
	ke6Tc97AQs96C3TOWd0xPyZ5PfZ6IPs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R 81bSYb";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=W1VeU2RJ;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761049565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djRtuDlRtAFjq4Z1PijNjMkRiGn4dBTVZ3HLF99zBu4=;
	b=CBGYo7hAVZsv7AuOAXCHtXToLSWuLssdDdJIpj/HQ8CrYnBNdAy/pvIZ7ieqRfhn/s35aR
	yrZiXABvMKrzQgIuV4g+3hEBJwMJvCx0XQ9C5Wus+FXxjZblsy4m5zNJ0b/rqXH/WcXsha
	vRE7Oo8+o1sWdxCs35Rbt4miMSB5vio=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 04BDB1301707;
	Tue, 21 Oct 2025 08:26:03 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 21 Oct 2025 08:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761049563; x=
	1761056763; bh=djRtuDlRtAFjq4Z1PijNjMkRiGn4dBTVZ3HLF99zBu4=; b=R
	81bSYbq5YLRO7a8qq7Hyv5a2M1QDd0MnFcE4Gs7wABPPJrpuoU2qbb9qEQH7zupf
	Q9OxbnaJxto1soDyqtrMR13kKZ8Hu7KiZ1bNVxWC5OrMid1Pg/IA8REI0HJyBTyO
	yKnPgAzft+AF+Mk1QNQ4QlULhatHlquF5ieogG6IU3D+bYCLIhu4e96wBkc/V6k1
	2nhx+df2oXkS8TVz9W5Xv9oAPc1YMirfmjRzqLkVajtYiTOn6P0e5UM+ghdXjiaG
	46huiHduyXyLg5hJ7WcEQPR/z+28ut/H4PCod33YkVBjOeKsY1bnTsp9D/n923aC
	Ee7cwsA18MKsuJKaZ0Kwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761049563; x=1761056763; bh=djRtuDlRtAFjq4Z1PijNjMkRiGn4dBTVZ3H
	LF99zBu4=; b=W1VeU2RJ1O8RBpYsWOK3vn6dPtBvCHrpWDNp2ISn8DJWwmN0c1k
	3Hdj3Fw8z4JIPy9ijoI+/rryCwYRx/uT1gyQt9Gzka9QQYohFRVxNlWua1HJUnCq
	Ilqmt0lllyhvwcNGamjVqwYAVsFgd+2SqzBbQPRbEQZZLLrmHM10y1QvenA5U8Yu
	NI0jzcFdFlz9dL7bvAvluMMvORo6ATDuTJfE8fAjSYDXeeB/+hOOp00X8x6EtgGw
	jaB3LkFVZd9vJIFY8/Xsj6pWFmjpHxFWDytBYWeSKKcKCvm4/E5et0vOaidUUgBD
	EFrvup6vyxe3fPaW2v2/iY6YlFNaELtnjzQ==
X-ME-Sender: <xms:2nv3aC7g3KMh1zu9rIreypk69t2XA44UdZeDu1eaz3rwcVGVB9WwlQ>
    <xme:2nv3aIFzgacwgrZY7u7o5iOZYY-cfozdH_iUzqqD3wcK6BXTKGCifDa1OmRNJIJB6
    ybQBzYMB0HrfKU3DbLx8pwzmHtzhFdVmJ_KgqNVikzxk7SxuOH1Cox2>
X-ME-Received: <xmr:2nv3aIl6oP2krUWtNALHbluoU5q_J18FmMR40lo9EXB-5Eoi-QJGp2_fZIUXnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugedtjedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:2nv3aKukQt5za1Jz9rGs7ZcEADvoJuxotbX_8ZP18Gs8EdZOaojR9Q>
    <xmx:2nv3aHdeaXuINDxOlvFdClzcuOqU-2taodAuSvqV4w_yX0dQbaOElQ>
    <xmx:2nv3aGb4LLDOmP4OxuDcoUL2038i2PXStur6Kz2dADMxARiyfa-IwA>
    <xmx:2nv3aEyaRnk_Xin70yZojUWcBUueOqPe138Zjx8cOl38HmUCYM8pxg>
    <xmx:23v3aFjPnu04kFNHdIzLR4y5NizJgqd4xCMVi5ELzI5CfbB0M8QCfrGf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Oct 2025 08:26:01 -0400 (EDT)
Date: Tue, 21 Oct 2025 13:25:59 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/truncate: Unmap large folio on split failure
Message-ID: <vuvjogn4ivkf52zcdhgmu3pe6lwjaqauljmsua2uyzefrfk7vg@gir5o6uomem5>
References: <20251021063509.1101728-1-kirill@shutemov.name>
 <20251021063509.1101728-2-kirill@shutemov.name>
 <a013f044-1dc6-4c2c-9d9a-99f223157c69@redhat.com>
 <37ceab54-c4b2-449e-aa46-ffaefe525737@redhat.com>
 <eokncpih37zm7ypt6gn5xyetx6jlemhvvfdzpmdlxleqlsqcr4@45h5w5ahwugs>
 <e4349d5a-33e8-4b8d-b1ad-6192ba00ff66@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4349d5a-33e8-4b8d-b1ad-6192ba00ff66@redhat.com>
X-Rspam-User: 
X-Stat-Signature: aty3xwqhhmyhmwgrfmykzf3ytfyqohyx
X-Rspamd-Queue-Id: D30AF1C000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761049565-442844
X-HE-Meta: U2FsdGVkX1/WfMZNCKNqtj1zy8fus+MD2ctugJ8GIWvXasKCXt0VLYAm98x8Mqu/o8TWSHIZUi2Pv2tVzovbpXHziP3+xFdTlshEB+aCiPPDh/xlYrgVerGUGZG5qDs+2bFL0f1NmE6hvSbaCdopStjbeGYEVrJfnlaWAjUVmsI7CresbT0M68/BOp3asTrWfxGDFD5AxkIiZ3kdjCS/0lT3dhJupJijYysyNfIDFYAFc5bU41XX8T+TbuPasVPDnKmEYw59qYX0tFNREHhKQXXanyNL+Q1Qgbp8bu07QC0SScNkd74mnBvVBP5bXlxjb0kyyerQOj+n6xSU4sgZlgampABFBETK02DAYVm+YR6/oDPRorFTBMY817bPkGErqcUrYoG8YSxAmKWb/6F5xcOAgKPfY9gnlgUxH4JeVJxkgC029LvfjYa+P1Bdy9aJgkDmhvpzTdbZjnTBL04cHK403ClXWjb4PI5G9jbWTTEDYhYkffRzm0AB2EBsvOp75/JPZ43Qzabij08Gnz2upIEPLPppU0iI01wpAFURmbrW3PggNxCHXWQXywHMXxDRRHfJiW2rI5lJmzuLB7oLeNWvSVQncTI78YjZ4ykgoY46kRYdLn/wCXQeysM/qqnz/NJ7ZQGzHBOqsqZaPHjfUVEexz5rVNwXN8E2tzZ+iDvitZhXiHYVNmHOIeX/J//M8xE29TAYMNHZIrowS9U7a5w1tlZeGc1YSib0uAWp26WBHX8ErE5SOTe2Ka0HYEKHc86IC5j8h2QxLmMpqX/oTRRoztUy3/RIOEOXvWsGu8JsXHhHuLUQ/GUF1q9JXNCgsp1QIUR7nx5Vi5qiAwM0TVfca0VhJyUG6NGu95xQghswL6MkBc+zixLaj4lfDxBRfUW9gX4MxJXhA58GuC9G8NYhgBTONRG++l6WoDfqc1iUPZNEXgn/onbgm688/Evk0HnWDhmA+F5tk4L4kPW
 yBF8Q/S5
 zr7cG7p6Y5Vp2yjgyw9cRuMyVbJ1EtJIKb/bXR+fqwfnLouvTjPZHrt6+zVzEqJhVigNNnPdT421A2c6joxq9M1iWvO1LxEsO8xe/CpIQsc/Ot7HJaAq+VAfHWkLCWR2hfX8j5W4RKYhKcGb0JB38j8TTrAwBsv9+O97gKtrhVRfHw8B93kScl/0MBwe98E5Ox3DrIEafk7dmATcvoXmSbLBlMCuFO1IFCU2KGnVco+TFsG65yjAqOBzxI7erPNFC/PIClU8KGJa5omdNlPJnPOgMaeht7fSzpIr2C7dwHphd7/hypLO6RU4v02omoVRA0HynnsK/9JKffNtHHkCGmFIFA5uzJRf9nMJEY9XOOy7V1SJsVRUTrYjEzEc9NYl8QlQwfofRpzu5dKBUmDZLZbQJsLhAEHNbHyvMDinahatN5jU3q0eyrPik+phtzYBPonIUogk70wvJDEZACzPEo4NK8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 01:54:51PM +0200, David Hildenbrand wrote:
> On 21.10.25 13:31, Kiryl Shutsemau wrote:
> > On Tue, Oct 21, 2025 at 11:47:11AM +0200, David Hildenbrand wrote:
> > > On 21.10.25 11:44, David Hildenbrand wrote:
> > > > On 21.10.25 08:35, Kiryl Shutsemau wrote:
> > > > > From: Kiryl Shutsemau <kas@kernel.org>
> > > > > 
> > > > > Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> > > > > supposed to generate SIGBUS.
> > > > > 
> > > > > This behavior might not be respected on truncation.
> > > > > 
> > > > > During truncation, the kernel splits a large folio in order to reclaim
> > > > > memory. As a side effect, it unmaps the folio and destroys PMD mappings
> > > > > of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
> > > > > are preserved.
> > > > > 
> > > > > However, if the split fails, PMD mappings are preserved and the user
> > > > > will not receive SIGBUS on any accesses within the PMD.
> > > > > 
> > > > > Unmap the folio on split failure. It will lead to refault as PTEs and
> > > > > preserve SIGBUS semantics.
> > > > 
> > > > Was the discussion on the old patch set already done? I can spot that
> > > > you send this series 20min after asking Dave
> > 
> > Based on feedback from Dave and Christoph on this patchset as well as
> > comments form Matthew and Darrick ont the report thread I see that my
> > idea to relax SIGBUS semantics for large folios will not fly :/
> 
> Then I was probably misreading the last email from you, likely the question
> you raised was independent of the progress of this series and more of
> general nature I assume.

Right.

> > 
> > But if you want to weigh in...
> 
> No, I think this makes sense. It's a regression that should be fixed.
> 
> > 
> > > Also, please send a proper patch series including cover letter that
> > > describes the changes since the last RFC.
> > 
> > There is no change besides Signed-off-bys.
> 
> Then point that out, please. It's common practice in MM to send cover
> letters for each new revision.
> 
> For example, Andrew will usually incorporate the cover letter into patch #1
> when merging.

Okay, will do.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

