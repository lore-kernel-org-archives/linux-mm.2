Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB14CCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE9D46B0088; Fri, 16 Oct 2026 10:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2AD6B008C; Fri, 16 Oct 2026 10:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7D66B00A9; Fri, 16 Oct 2026 10:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3BE36B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:43:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F8E5140459
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:43:42 +0000 (UTC)
X-FDA: 85328758284.16.D1A7E76
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	by imf10.hostedemail.com (Postfix) with ESMTP id 27243C000B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:43:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="W t4cDLz";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=PbQasFDQ;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792161820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7YiqwWDZQk+2n0xT60CqKD7dnGue7NdCKkacoM2NUY=;
	b=fYIaLXHHg2KYQiHXYDHWmFv4hEdvEKy8sQKs5DwOzYxsdnOodWLKZOzq0PC+b0HsIVHiQ/
	y+Gmifj9sqAw8BXY3VS+dC3+TdCaFDK5vLACFk5jwnHnZtpWbvE6En6qnnavHvZvVTuOyx
	RbaxpeG1sqwBh/YSX/nd4a7f3xZGCRE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="W t4cDLz";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=PbQasFDQ;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792161820;
	b=b8GFtttZQvGMUAC8vm19JSQjxnGRE96YlWqzFffUVWKR9RjodgcI6M6XDzAmqmOjcRPHUE
	2PKdLC6ema+PiaiHgIVeAGBHBJg8fpJIQSaKAOCyEjSdFEKgOIc5rKdnKI0j4wOazzxn38
	aZer87BNSoAcaZXt0anySFHTFv97XgY=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.phl.internal (Postfix) with ESMTP id A3F1A13802A3
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:43:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Fri, 16 Oct 2026 10:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1792161819; x=
	1792169019; bh=Q7YiqwWDZQk+2n0xT60CqKD7dnGue7NdCKkacoM2NUY=; b=W
	t4cDLzfwd1JAm9iWky6dsqe1ygMvsiRilmhlchkEdz5rL1qXHKlD8RGB5fcn44I3
	YZTFc5AWeEbCw/OSotMAhzf/m1CsCFTjWrZfHBSvZuy/Z/a5HyEB+uuQoLFuDiFE
	KOzgMhOluq69GhBgVjT6g3lxqluTSIWnDvyHAbnG2bx3rDl/KIdNw+0GHtwGroh2
	3HDNxwOwZcPdtbfDUf8tvg7Z5rZDUTDsjm8tCTawwHBhY/6KoiuwoU2e1S2zmwwk
	sFQQTasOojUXpmsyWpuMQV+bnkMpR4GtdvNLAicpnmuwfhG7cuI87aunpXrKEU8D
	zzfMfBzUx/RHn3m6C/oXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792161819; x=1792169019; bh=Q7YiqwWDZQk+2n0xT60CqKD7dnGue7NdCKk
	acoM2NUY=; b=PbQasFDQyrQ+A+8cKn4D8RjfMmBlPPTeZPRRj5GPvCNZBEk3Htj
	NNl1MtIIEF450FCpPI78sMx6K9B5W2DrVbblEX8gCDAc037ZtwmDnFVFPMa1e5g1
	NtRLEoeMPDpLlLqBjXjXzxAUStpbWYSv1QY5aauQArmYQYDZQoFt3GqXvL4ZHCV4
	9PbjnFZybxpYw3dur/4VZPUY0mqmgV3mSTO3bYIV+mbbOtrIZCtayRziOSJFoKKc
	g2Smep7j1ooX8Ycb7HJYLNOoIdaa+O8iGrzH+qoaiFa6ZZcNoZz4i279OjBwo2PX
	2cn0GaSd4d/wh1vHrD9KSYkeQEyl2/s13vA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792161819; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:ZYwg+2kNjwNz7WN6trLmcqfb4kyyLlpcs7mQ+wpDVmu9uGi
	uXxKMr/CJWwJCq3tfMraPXDDAcZXNBGdiNV/IP6x04A2PLK14TeYMQed/7EefRfW
	5O6y+b6gBrNJvzQmyvy9ZU/tcn9uYvzBpnxOCu+eIytgEeq8tHtfCydlkG68AlHj
	zsGaDnAvvtBUFJvUGVsdf4YtyWpt4oWVUss0gy9tKvl7tapLPKjVicUnpZnlucI9
	T5i2emlUgf0lKV/TH2sH21YyXRD6JAn7SbVLzHLHxuEN8nqTMpNQTIX7Mcm2Hg4n
	KKFTFoIYPUb8xNVre0EqWfB4GGUA3nDsSBffExQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Zb7vPP8S+mofmUXGssuNEJW2eqeSaoQC/gKcr2BfKcM=:pNdXBEgtey5QskBpU8A7puCi2oaNLXY0APuCxhs8Xjg=;
X-ME-Sender: <xms:GzjSar-Y6JCeXGT6Huo2WILtsWHa7904jsurZ4DRN8aeOgJ9h2g8Tg>
    <xme:GzjSasmWqSBlrS43RLvc5V-LGAJE0NLE6vtPm_VJYxENPemSq_4AQmJ4IPwWZVpbP
    OiJcOnKdLqYnVYnfPONbV9eLaXTeSTaEKBrrDGFCFNkOnQyJ_1oZIYu>
X-ME-Received: <xmr:GzjSamnaJe19cukq5f3SeX7NLQ043stsfCZNBKmsZLZIZVzstwwE285Sz18>
X-ME-Proxy-Cause: dmFkZTGPCwNLlIreOA8d/FUYkTGC+HHrYcO9/o1KThzMkoChb947LgMAYu6dAGmTNWyiri
    Rz7sk3NorietT7VJbAz/9bYwJ7ebwYatXcyTZIhsmGzgJAEog3F5mvpcw2wtCMDP0s87kD
    7G4Wr7Qz5MO5JKN+als71og6ex1cpr0AGL/3D3N+/lIPTTy/rki+kL8DvA7SVvSrdyr2IJ
    pvrqI4Q6KxfSOOzun2NE6+zs++YlosAPx8a10GtjyisOYVmdso4hVVxElXTQPnxZAzfgg0
    rOLrmw/KNpWVBQ20YDQqeQsPZBQM/xGUZP6xODuxvGCs10JRBZIZB8E2xK2gIrrtgVnEaL
    vWzddWLyXsghBiq4MvB8Qjyjbcb63PddmiEFM+Y0ZPEXWDXLPmer2ZeEIUniPerz5JrbAd
    QsMB/J9ahY5WTkFRKQhFngpecixgjgTSmNZ0dmWVO1m/TdI3KySbBO2BeGodg1ZIxXhOTX
    SI4TvIf0A4MsuieMbWwGzY/UQKZhp+XwKcEEHmuMFz75RVr6WFYQKKvZ/yQlEhwrmZKcEG
    8uapbHf/m4fNtm5Nl9susNBmOzhrlkNy5zNFx2S2E5etMFhMd8N+jVS4UgWLJNpXi0h6iF
    PCjxNQ1Yn3DJATMrR2PkPdwQ29HO3Lavjy+RivU/ogtSNHGvQM8N/5ShmeaQ
X-ME-Proxy: <xmx:GzjSapgkx26g_AiG54qvD69YL378c4oNk0EU-73UJDDTMe7d0Suqdw>
    <xmx:GzjSavV9Ez4XjQvO1WHp5NH-wFab5uWmkOKC8Qlwp4yMl4nu-hUiJw>
    <xmx:GzjSargGfVMMmEz5SdUPlQFfOmkA0i_9l9N6ovTrhkR_UJnRvKyDrQ>
    <xmx:GzjSaj5soupLuMsVHj3TPzWqMsytwQwbeXYvZvnr21x-kZdK9qyt6A>
    <xmx:GzjSaussv_3R8BX44BJXCqD5NLcEzX9RUw7Zdqdo7QjmBwe7HEH9MT7N>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Oct 2026 10:43:38 -0400 (EDT)
Date: Fri, 16 Oct 2026 15:43:36 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Pedro Falcato <pfalcato@suse.de>, Harry Yoo <harry@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: Improve page refcount scalability
Message-ID: <atI30-1q2iEFPEbR@thinkstation>
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as690Xcu7FxIDYjf@thinkpad>
 <CAHk-=wiak+h+d2tZ5W_MwRzatUP=hJKn7cpGjDxArG-gwgHLXg@mail.gmail.com>
 <as9-2cIuGuXwE2Oa@pedro-suse.tail5790ac.ts.net>
 <CAHk-=wgkoAuxNXga29nQ8w7GxdqR+4vPAUhPsbfp+gzKrb9EgA@mail.gmail.com>
 <CAHk-=whzkNzkBmCspHYd80D1Z=krDc4SgVC32=pJ5PtEgqSDrw@mail.gmail.com>
 <3c613725-406a-4506-b788-987a337b9771@app.fastmail.com>
 <CAHk-=wh+1Hz+3HJ8evmh=FKO1fCGiwuNTqArXEfe-tAJ6hDy0A@mail.gmail.com>
 <atA2g8OgpiNOiVL_@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atA2g8OgpiNOiVL_@google.com>
X-Stat-Signature: 7yzpsduf76ebq7wp4wrcn9gt48859td5
X-Rspam-User: 
X-Rspamd-Queue-Id: 27243C000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1792161820-953357
X-HE-Meta: U2FsdGVkX197I73vtRXEMotcQkATdjHArE5T1WsT0i7MDjNGwVGdKx6XWt4RCJtacByg2ctpW9aqBj1YKbeH4dLrQEo0xfPwTmmTi9kyDAWIgVE/xASNSDpGBqIj10A1rPuLHKa8HwKWpgwdEWFfqBuAzCkSJdc6tO3OqymyNfl0a79oRI6xxyeGh8uFMm3pfmNZGj3LHRhQaFV+F5+dTFwcUqquozWUS1tPR0CJyLrQ+B47RDbvehJTzHcHmE5CSVAtkoZApwun7A6HeXCGh+fjXVu7rI/U6IuxysS+xSdsK4Fhx8k3G3CxteNm6L/8GxgOELao2jv2UWUzWvk4BsM75dK83uBH9uSFqk3XhIBcNxWC9dFy5V2jFZtupDG4r22KYhDT1DnoHsBQEPX72NIL48bRc9w4eTDWYsS7GPY9BIihOMk+nDrA0Y7u8YgVm2T+qbymzsqf7fGGGGoH5wZN3PhmepzoeRbUH+DiPNo4VdZiZEfV2iFrKMRz+3xxfHIMr1h2z393+Z3D1zS6KWVtofgRhS0d/dBRHQGv7bsjc0RLLn9TrQwEzvBks4m/nf8CT0QL2k9k89ASFbKpHN5/MCAuRYMi1i7GlkDYS8hUwM9gaB8VXqJTi+joaVPtFsJcN3o4w1QPLqsaCyxuGGivKzCcO1ioj0Nixz4U5YzOqxrkgy4tm2+zFsjJwUfThUG8nz/GWV1ObvNMqQFZ2Pe9B7nJ9MvSJmKSqOwYVvAHLEjwepsTJlEnqU6HC8cnJCBPtywDB/ogCH2KWLfRzaDfqQ0UF+apevM3JmWM7PsYljg5LXeZvJ1DwjnT+xRf9+/z0Bga59Ijx7JjGvNLBH6KhGoNRcdvQMx+D8dgRmtioSrRMm2Tco/47NM7SXj5UEglDMduVnaCuptab08y8b/1ztpaf2CfzUI75SxlsbLM1qP7g4D87bnPtQ+8c5Q/UzmzlpKaInXMOnt08Je
 B3kjBjYN
 vfBCAE0aq9hksFLLQl1+JSCV3w4UPN75OGA/vOoNQBIAzirIV7VkgFVpAYwLZqfQPVgTrgzv1LEIO9CMcXHMzToVI9eqxKnUNKGyRu4zSWOk+g9e8E148QHi0ZNvpaoQeF54Im5BGlYSH+5Uytfkxp/GD7OGbguT3N5N4iHmgbq3KwJOygL8967/oCuHORSbXNfe5Uv5NDZn3fyuZ1stsBf5GYooekUrJVe69dIbMWH1rQXEyxU6B40unYI+WB324bEVcoKomXdO0oJ9aW23lRFM3EYySHQHstrycYNjNiqWBQf0qYFzp2OBKv1jZHms9j4tQlGmYzWD0PuGsafbNRGW+kx+++94WZGa5ix8eahjmV+ADYwYDkGooRkDSiDmyYUgjHZXqtaKFYmxCeDQAp45StnVnsFuRKfCQxpwX4oq0XAOB0CyBP1/dHi7TUU4A+lNGE+A8puOzrEcT2izh8Cp0mgn/T1ARaVZGt5tZ5JnW2j21kUVXx3Ae/lHm0Ulao6Od
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 02:12:19AM +0000, Jaegeuk Kim wrote:
> Indeed, it's a bug that user can see zeros between F2FS_IOC_START_ATOMIC_REPLACE
> and F2FS_IOC_COMMIT_ATOMIC_WRITE. I think we need to move the truncation path
> into the commit phase and use truncate_inode_pages() instead.

What about f2fs_abort_atomic_write(inode, true)?

It calls truncate_inode_pages_final() as well. As far as I can see, it
runs on the last writer's close (f2fs_release_file()), on flush when the
atomic writer exits (f2fs_file_flush()), from
F2FS_IOC_ABORT_ATOMIC_WRITE and when F2FS_IOC_COMMIT_ATOMIC_WRITE fails.

Can other processes still have the file open at those points?

AS_EXITING is never cleared. Does the inode then stay "exiting" until
it is evicted? If so, reclaim stops leaving shadow entries for the file,
and with the rcu-free series a hot folio of it could be freed without a
grace period while a reader still has the file open.

Would truncate_inode_pages() work for the abort path too?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

