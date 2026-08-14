Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D16C2C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 15:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B48E6B030B; Fri, 14 Aug 2026 11:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665106B0317; Fri, 14 Aug 2026 11:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57AA56B0318; Fri, 14 Aug 2026 11:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4856B030B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:28:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6D96C0198
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:28:34 +0000 (UTC)
X-FDA: 85100256948.14.FFA39BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E83374000E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:28:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOgTfaKe;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786721313;
	b=WbuejFPLEmNKZY0z+leE9OUmMr3qgGJ9aaaA2bEpFLDUHtJB+h/u1zT2AOwfmCASp9bMLK
	z9jSSFUP5woF1E+jgXnC0YAlRJPzcbaCkuPV7FDnfR9slepAyC7wwDJoEJBq7X7bmc1fpB
	13AjsB2PScujWQGlhgioYpJz8HpnNc8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOgTfaKe;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786721313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfnvBXRVOTB7UT8A93hr18ROs6Wwefr9xY+1heqpBJs=;
	b=PluVP/brHPOoI1EL+noU/5RF0aasQ0tyA8iB6EBNjiy3GLIKhYppbxNUezMG1rf8qqYZYp
	FD3jEhNw9rqe1NTrFArzuDh74A4rJXbU6D08q/FYqXiRBaoK9KzU7mX/Y6wI7T/b/qBR8r
	XRe5i4iRq9DxwsmjcE4/arWqeoZIPUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D67D143952;
	Fri, 14 Aug 2026 15:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7390C1F000E9;
	Fri, 14 Aug 2026 15:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786721311;
	bh=hfnvBXRVOTB7UT8A93hr18ROs6Wwefr9xY+1heqpBJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IOgTfaKexlHmfyEydeEBLUvjl60WHSEyWt/VjxtmEpyqay1FoofA6G96R9QKQ8mf3
	 8kMNHXq52CPyXTyTdBL15v6jkqdIjLybowkEjHtwArjmH1fYuVIA5ZZJIf4A/DHJTQ
	 THmH6zUE04N2SSf0uSd+wrINct/KBc3GsJfcYPxJW8Xz2nIkcQDhU3rSiLYX0xc6aN
	 Yzd4mlrzNf3DOziy1xWuTFsSq2U7IBUBqHnT/DhEPn/8m6Y88Hm1EQwTDi0NfUPfXT
	 4qWMr36pZYY2UcuRNXsNajrV5nZCtQ3dWD4Dbw21ErQUxNezHa7XrHSPXFoBLqsHxL
	 pMAmycp/38pcQ==
Date: Fri, 14 Aug 2026 17:28:10 +0200
From: Christian Brauner <brauner@kernel.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jacob Lalonde <jalalonde@fb.com>, 
	Shuah Khan <shuah@kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 00/11] coredump: allow to create sparse coredumps on the
 coredump socket
Message-ID: <20260814-geflecht-sachdienlich-ergibt-c736999f80ff@brauner>
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
 <an36FFL9ALwCPhEe@telecaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <an36FFL9ALwCPhEe@telecaster>
X-Rspamd-Queue-Id: E83374000E
X-Rspam-User: 
X-Stat-Signature: x436upnhi5fymwj8ucc3dpfg57cn73nd
X-Rspamd-Server: rspam06
X-HE-Tag: 1786721312-943190
X-HE-Meta: U2FsdGVkX1+7j7fa8pJXSZzreBF/foFgt8KtoKFLgQ/nZMI51+XZdFBICOB8LOD2GN7MkzJ6e943O6js32q5OOizWOLH70sjT+6q6AOXzUgFFkdrPmvledD6IaXiU76jAFTw/kQz1qpqRew54NfVg1jIyWPbzVpVipxkQMiWYrgZ3YGJ7SN7W8pCvcxq0UkrSbH7pTz0Qhz2SnZy8liqnDuD/nI/7z0ctU0zQ2lhYIW/mD27ZKqfmK+U9c0gekAEUbDKA42lKoz73fF4R/Cf0wGAR8+KWJ9hYZaOWsI9EEmHiwYtLwhr4ew/s0CuFCuxNBigX6fsHdFdg9D4ru92SG3oDH5DVuT2++0OGDW65mlIe2+1+biKNNGBBR4kN6/JBOwjJqd7iLOiSwxwghDkNJs+8Ff87CvY0IBHKE4K4ynVcaBhXIXM7mfHsr/2Wn+n+5i3TIrYtpzjqhGO0L353CybCetiEmYReuxhzyRurfKaYx+czEb4NAEdQFmOEu/uhOd6nvv+PsuOZkE66uOvq406/jkYX3WEw12YP44OoPTJtbNs53gYgngE/8sMiU82Lt4vb/zyfX61xuAOt+70oCdu/b/lBNV4J90ESWyN/9du2RFAA0Q+vQCE5onP5agTUaobRNU6np3pln9+PIiDw7DIaYGfSWS9HVkYctO0ANEuipU2pbZdxvp+Jpb5SlcDwboR8+iZuZ3doFfVGj5n1+N5q/tcTynsiNaEJ+/QS5CJ5+s7Fj56VH32zit8dniG2eqHVZ1JL0mk3UOX8K6PO8iwKUPA4ozrbc0Jrg6/94iXaJd2eoHK0RCB6v5a0UZw5PefluNZQ3JhSgR+zNnJZH7O2R5toiPeZzONcLCeGEiTwHQzN6SZQx1nMZHYDjYF/w0C/KLPPZrcAX/Ee/Z/3ussk4tix+YUKWrU3fda45PTBMUrYafJQNe0rOzJ3aM3txWuF/fWNqo3SiF0Tos
 hUSam5GS
 cxQPW0FYZjXJv+CUv8YT1ekFCd7Bzl+NIZbXGpSGcrwKJw1RBBDd228BYBGFs42XnpX8C+s+balYfex8vfuzuk07x/wk6B3/oH2jQ+eLPYjw6bepgxyxv4WolWSvNnCxrx/RSbuXEZPjWkBYnTad+BiNC43j+Vc4iV2fOk64Gk1eVMtntZfbvcBiV0auv0QKEdl+2vRprrlZkbRFTEh1WKeHJqYPq7YwWFsZOZVoeNHXltNNMm4+fjRniT2d/bbUF5U9vGu4o/NF/AKMvfkOfIaWWCj6pg30lQjUSC/QH+lARfGDNBILK/CqhP/WMP6XgrRr3c+0QtrmiwHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 10:08:36AM -0700, Omar Sandoval wrote:
> On Tue, Aug 11, 2026 at 05:27:21PM +0200, Christian Brauner wrote:
> > A coredump generated via the coredump socket ends up transferring
> > zeroed data when a mapping contains holes. For a large process that
> > maps a bunch of data that's wasting a ton of work.
> > 
> > Jacob ran into this and Josef has bitched^wcomplained about this to me
> > before. I dislike the coredump_filter bit solution in [1] which stops
> > each PT_LOAD at the last populated page.
> > 
> > The problem is real though. I don't think coredump_filter is where we
> > need to solve this. That mask says which kinds of memory to include and
> > it propagates across fork and exec, whereas what is being selected here
> > is an encoding mechanism.
> > 
> > I also think that the usermodehelper - may it swiftly die - isn't really
> > salvagable for this and it's not the future anyway. The coredump socket
> > already has a handshake for stuff like this.
> > 
> > I always had an idea how this would look like but punted on it back
> > then. So here it is.
> > 
> > A server that raises COREDUMP_HEADER in coredump_ack->mask doesn't get
> > the coredump as a plain byte stream but as a sequence of frames. Each
> > one a struct coredump_frame_header followed by what it describes. A data
> > frame carries its bytes. If a server also raises COREDUMP_SPARSE, zero
> > frames are sent for unpopulated mappings. They only indicate how many
> > zero bytes need to be written and to not include data. Reassembling the
> > frames gives back the same coredump. A debugger and everything else
> > still see an ordinary core file and nothing outside the coredump server
> > has to learn anything.
> 
> Hey, Christian,
> 
> I proposed pretty much this exact solution to Jacob, so thank you for
> writing it :)
> 
> There are a couple of reasons we still wanted to explore the
> coredump_filter solution:
> 
> 1. Our core dumper application is not really prepared to run as a daemon
>    that listens on a socket, having been written to be a transient
>    usermode helper. But thinking about it more, maybe that's something
>    we could paper over with systemd socket activation?
> 2. More importantly, we sometimes write core dumps to disk and sometimes
>    upload them to blob storage. For the former, this approach of sending
>    holes over the socket is great. For the latter, we'd now need to wrap
>    the dump in some sort of container supporting sparseness that all
>    consumers then need to reassemble. The coredump_filter approach
>    doesn't require any changes in that pipeline.
> 
> To be transparent, I still prefer the sparse socket approach, but Jacob
> has different contraints that I'd love to have addressed: it's a
> trade-off of more work on the core dump server side and all of its
> consumers vs. in the debug tooling side, which is mostly already there.

Hey Omar,

Good to hear from you.

I think the coredump_filter solution is just the wrong approach. It is
a hack and in a part of coredumping that is riddled with bolted on hacks
already.

And I don't think the argument that changing this in userspace is
somehow not possible holds. It not being wanted is another thing.

This is a new feature and as such it is our responsibility to expose it
in a way that is correct, maintainable, and clean. I don't think that
this is possible in the usermodehelper case without doing really hacky
things.

Plus, I really want usermodehelpers to go away. It really is a CVE
machine. Most of the ~40 CVEs in the last 10+ years have been in the
handlers. Mainly because the interface is really not nice and prone to
security issues. They are spawned from a kthread with kernel level
privileges that userspace then needs to drop. So really, changing
userspace is a long-term self-service. :)

And yes, there doesn't have to be anything long-running. They can just
be socket activated.

The pull request that's up against systemd splits this out into
systemd-coredump though. So PID 1 itself can also be coredumped. That
daemon is long-running but it's only job is to spawn workers on incoming
connections and maintain backpressure. The listen fd is in the fdstore
and so survives restarts.

>    consumers then need to reassemble. The coredump_filter approach
>    doesn't require any changes in that pipeline.

We could add COREDUMP_TRAILING_ZERO or whatever so you get that
truncated behavior over the socket from the earlier patch. While that
will get rid of smuggling non-memory type bits into the filter and
won't have the fork/exec inheritance bugs that the other patch has it
still has other issues.

It will always have to accept an O(hole / PAGE_SIZE) walk under the mmap
write lock before ever writing a coredump. So a JVM starting with a 64
gb heap reservation or a go program with a large reservation means
millions of probes before the dump even starts. The selftest in this
series dumpds with 256 MB. That amounts to 65536 probes. This seems just
wrong when we know the holes when we emit the dump.

For default 8 mb pthread stacks that are in a single anon vma 4 × 8 mb =
32 mb == 8196 pages only 8 of the 8196 pages are resident. Most stacks
grow down and glibc parks the tcb at the top. That in turn means every
hole in a stack is a leading hole. The trailing zero hack cannot handle
that at all wasting a bunch of space.

For the blob storage thing you can just upload the header last. So
stream the data as the records arrive and compute the corrected phdr
table at the end. If you're using a temporary file or whatever it
becomes even easier to rewrite the header.

