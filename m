Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E95606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 21:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UQYU01VS
Received: by kanga.kvack.org (Postfix)
	id 180A26B086C; Tue, 24 Nov 2026 16:54:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132456B086D; Tue, 24 Nov 2026 16:54:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0470F6B086E; Tue, 24 Nov 2026 16:54:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2BBB6B086C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:54:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53DDB160C6C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:54:26 +0000 (UTC)
X-FDA: 85471366932.27.79C41FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BBF8440006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:54:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQYU01VS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795557264;
	b=Iq6+F9DXfbkGJqwvMYcmYYMLwQ3TC7Phqm1fQv5+fN/tbSm0OWSxe9sOddGU3PliIN41Wt
	HdOxko53tDsw95x9Q7d4it7tWzsdG/25mmzq862iLCO7kJ9F93KNZQ9OqTs4PNEsi2wBgg
	57ADuz1qL+V8B74/fNBGiURvIFILFW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795557264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYhaZ8UGiw+YlICT6cuZY+47kv3MmX1z/3eT4sdMXTI=;
	b=oADeaUq468/FxXSAosnF4tjGS+yjAQwaRKz/pVKjnvTC+nreSqXyUA6Z5QOtC4ulNkuBJT
	sDW0FgNYvmSfkSWsVNCvuzPd4XoBuCFjaJpAm10VBVV5prrnTxTpbWnw48o9vSOVBzW+kz
	vxmm+BK6wIIDOXpOn/rt7H+2XFNPyuM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQYU01VS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13816620B8;
	Tue, 24 Nov 2026 21:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0CF1F000C0;
	Tue, 24 Nov 2026 21:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795557263;
	bh=VYhaZ8UGiw+YlICT6cuZY+47kv3MmX1z/3eT4sdMXTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UQYU01VSY4vX+sjbQbe4c6VkSB0gsZ2dNNQyUjzPr11h6kxp+XHLGI/piPI+B1UeM
	 eRUe1De7GTvpy3OMo45cZ6m16ApzRLuHqFmgC/VuI1yJaDOiK87jAkWeCB5Tp+QHT0
	 vNtZ+nhubzxAPXsM+wKtAucuGu5fwIu3pZ4YjwTQiPzvK+WZGmL1inBKzz4fdOSMfv
	 dlYLUpjD3/VUOPgS82hY4iy7MAMQd6o+sVnEzBSfpc/ril2HHHOwOGEp1+UbEBJK5g
	 1RxVcindNxaBfEAQhYfDQ37uW15Pv/CepKQzGQLxhTxMfkTxJqA4HGLKBlSgS3Tvy/
	 pLHEGkvPsnszg==
Date: Tue, 24 Nov 2026 21:54:21 +0000
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, 
	Lance Yang <lance.yang@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Ying Huang <huang.ying.caritas@gmail.com>, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev, linux-riscv@lists.infradead.org, stable@vger.kernel.org, 
	Kirk Swidowski <swidowski@google.com>
Subject: Re: [PATCH] mm/rmap: avoid reusing batched TLB flush generations
Message-ID: <awYFSeZKPzqcCvW8@thinkstation>
References: <20261124-rmap-v1-1-e3dc48a4b527@kernel.org>
 <awXQg94rksZvexZe@thinkstation>
 <1cd2306c-eaec-43cd-9d0d-92f8cb6e691b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cd2306c-eaec-43cd-9d0d-92f8cb6e691b@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: BBF8440006
X-Stat-Signature: mungnrxifzh7obexcixrgb5ono45myso
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795557264-756043
X-HE-Meta: U2FsdGVkX190NqKszw0hvwqKG+t2EnRHlermGFt/QBxsh8uASELhiXMbEhGtjSrEjFPkWX+OSoASCHg7wExsbohILWERuhBlVqyZGZWWrVhrOAW5gCHVcWHYtQcKUTeMMSbX2CUtcVeLdyQJPi+PtYo8QJEDqpSYVqtqmPCZiYK8TbpsYXaBueWGE8DfMfKDc4auO6m4rC7IbnkamL/AFc///8gdqGpyOvZ03reY+zywlXMJMCXEUVKxZkinODDqKYWnRRz/yvZF2MiQFpbar7gfTcza72Kz7Ix69qf1w5KGZuC2GLNQazVb/rWY8f1um66g+vWmgXnazyu2b9CYYn+NOG7V/YROp1ggEcb+HTWPXVKLEiNrHeqvSf95v0RNc6zz8tunsC5/omH/ScWB8lJ/45vuZYQKpw3Gz39gjAhm2pwI7UxQxs7gAbHM+A1NagBwo9lsKOa3Adek1WmM4vnSWkp2AuGC0kRhDcUDpiQrJEMC5ROL4a8qpUpEM9IhlBOd7NHSgNEkWZ0DEzFkDiqgUzG0kOXcTmhRPVZT/3HwIpI8jpZmt9zsHXWJXhOXqpVHBBXO8VknMzhNDSqxcgOBFFxXp8N71GvJJ/cShdheKaNk8QgNm9SoGyMtvR6DP4whW+Z1Z9WTh/8kuUlm2gvXk8DgoHqdZMH/040bsCm+IisHBb0amlFNW/sCrfBnYWybpV2r8xLBTnSzEtf7S3JFt+7Yw5CLHqWa2/hZy+92mQkwh1HZKec/ukwL421AbohYPOh4Ico1qNu/H7i43hn7YUQN/o1KraqymlzHU8x7Nr1r8pkqVT1nD99cVLSxpPwtfqUYhUhBRtSB56XoFECuh5vq7xtlVVo3D4HhIZJ9lHbUugZJ5wnIdG6Qn8qtEAoHKY//WlsTSQcPyMNm1qXn7bl/eVxA6btpbUfwZSGBMU929c/FXMZqzreH2rvsqyR/5OdgsnXap7cR9Fw
 V/AjpF3o
 bSWH6dqH9p25Iwt4F4HBCk0slIPHIz/ivmPaUYZWFCWEcweUN79dnKgsD34mDZPzte+rFxygOU4Sm8FjpDPP4zNd6ExDdVhoZu55mkf+IV9n/8r9qHshB/XOd//JgFA8w9z8GVzCNUKc6FToCABhkGzjqAMWC91EeVTasuhQAtEQfb/A+wmzGes3+wYMNMUsv5Ivf1Jqgo+WjI1XXOafSag9M0DW+nA0ju0oheJKR//m6TZyEDCN9a8oTpdYP5K16/A4PoPxQZEn7hilgcjxfWX2+4a0gTLrd3lwX5zmzCBl0Ij5ViLFeQWOaNFevv1aC6taV+PeFI7bX7HO8GyGhmr/ZmqDPTKcyL5nIPZgu9tSujTkHsCqx9zsKXLnFdOR+Kfr57bQXC6RDFnhDQaLesBJ92WxQyBKhXXDGpwWPQ1oMY21jkoFC24IckhUBqo6OYpnRoveVMv60QTPP515sXongCZdDzY1rayv/dYR8aP8lFPNynAlOdBkgMqd1Llj+6+IWAz4JO/IGlX239DxMTHX4/oTP3QuthrBqbu9x8ruccEs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 10:16:25PM +0100, David Hildenbrand (Arm) wrote:
> On 11/24/26 21:50, Harry Yoo wrote:
> > On Tue, Nov 24, 2026 at 10:39:11AM +0100, David Hildenbrand (Arm) wrote:

> Hi Harry,
> 
> thanks for all that effort!

No problem, thanks for looking at the issue ;)

> > Uh, I spent a couple of hours to review and make sure this is correct.
> > I thought this is correct but then my claude flagged a race during fork.
> > 
> > dup_mm() copies the counters with memcpy() and it doesn't know the
> > ordering. When flushed and pending fields sit in separate words,
> > dup_mm() could read them in two separate loads, but in the wrong order.
> > 
> > It's especially problematic in a very rare (IMO) case where
> > flushed == pending + 1 becomes true in the child (which means the first
> > pending flush in the child might not be flushed properly).
> > 
> > fork				reclaim			another process
> > memcpy reads pending = X
> > 				pending++ (X + 1)
> > 							truncate()
> > 							-> flush_tlb_batched_pending()
> > 							-> flushed = X + 1
> > memcpy reads flushed = X + 1
> > 
> > Maybe reset the counters after copying mm_struct?
> 
> Resetting sounds in general like the right thing to do. Ugh, this copying of
> random state is nasty.

Indeed.

> The child never ran, so there isn't anything to flush for it.
> 
> So what you say is that the first deferred flush in the child will be missed.

Yes, I exactly meant that.

> I agree that it's extremely unlikely, but we should handle it.

Agreed.

> We currently have:
> 
> 	if (unlikely(pending - flushed > INT_MAX))
> 
> So I guess an alternative would be:
> 
> 	if (unlikely(pending - flushed - 1 >= INT_MAX))
> 
> 
> pending = x + 1
> flushed = x + 1
> 
> (x + 1 - (x + 1 ) - 1) = (unsigned)-1 >= INT_MAX

Oh that's subtle :)

> But yeah, let's just initialize it during fork(), thanks!

Sounds good, thanks!

-- 
Cheers,
Harry / Hyeonggon

