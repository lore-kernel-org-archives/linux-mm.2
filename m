Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C994A606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K6Tg0r3X
Received: by kanga.kvack.org (Postfix)
	id F3F0E6B05B0; Thu, 26 Nov 2026 06:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16BB6B05B1; Thu, 26 Nov 2026 06:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E540D6B05B2; Thu, 26 Nov 2026 06:42:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCAD66B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:42:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31325A0401
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:42:43 +0000 (UTC)
X-FDA: 85477083006.02.BA72A7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5EF3840009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:42:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K6Tg0r3X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795693361;
	b=IUTexolYxNAA9e3TrmObCcJNpJzphVA84jAxvjKEN88VvCI1tCokNX5g1Pcrvu5t/0fryh
	HtV8y+5pmAmMD0HxCDuKf0Dx6lFGJTkie0ueG3bKf46AJ3WTPldXUPlBj9ThJUUFVUln4d
	qm5Kx3BiFgF0R/MW468qGOZ0A90bH6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795693361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQ9Dk6hIAYospo25vS7eUsQ5PcRuSfCG/o49Uj2yEW0=;
	b=GtEDp92dWvQGVPLAf4p0Xw/NTIj0l8gEWlHlAl8xlA/sVDGR7mzjBvLMzr4WI8ECHWR+Nc
	DX0WPUtDBqI0YuyXQz057YJ+UfDVMW3bBuI15jsIvkrP2HCn5b+TphP3ziW0t/mmuFOUoQ
	Zt28Lvjqtja0N4GtqsF12+uDLXk8bpc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K6Tg0r3X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6276240C53;
	Thu, 26 Nov 2026 11:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C711F000CA;
	Thu, 26 Nov 2026 11:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795693359;
	bh=SQ9Dk6hIAYospo25vS7eUsQ5PcRuSfCG/o49Uj2yEW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K6Tg0r3XiLLbVSA7Tt8Sye2tdushWj2CrKYZLrBP/cWphM4PnleANEOBBxmWox4Ua
	 mlqUDZ3v2qyHg7ebPrl8EF6rWOAaDTQcxFD0aisFYfg3bK1pXyWCu+Dp3IsVn2VJLS
	 5VPf/l8spPBHkDC/qiOr3Uviwk1b/iu6S/LOEk6L0VFMLTBLkqe2WrYYQxYbY/e+Oh
	 V/yWhbdAejyx7nxHGnNItaOvpTJBYzTPezssMzOyMo6E8QhgsTVrX/pRyIWMPiuLHQ
	 rnEJXVhhayaYDvzs+qn3+Rx8kKgyFXuYbcNoxoVYej/44NdvlV/atQVwkOk9SkKczV
	 NGCN5p7djeDFw==
Date: Thu, 26 Nov 2026 13:42:32 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [RFC PATCH 6/6] arm64: mm: support PMD page coalescing in the
 linear map
Message-ID: <awgbKPpwipkwkXPY@kernel.org>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-7-abarnas@google.com>
 <799181c3-a1a1-4de7-bc6a-576d3282efb0@arm.com>
 <akuieSDlbYdHnkCV@google.com>
 <aku8zidRtXPe_Rle@kernel.org>
 <awQLqYbrrgwUycxP@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awQLqYbrrgwUycxP@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5EF3840009
X-Rspam-User:
X-Stat-Signature: gqrsupii1fr4p87nw8a9qit9rott6ytg
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795693361-196768
X-HE-Meta: U2FsdGVkX1+w7JYnLv5qwcU7gImKxPz/3BEAav8+ytFfA1I5Jvd1ikQGL4fNwE+6aUKRI9pK5w3fYBkSiVsSqnZ0F887hakxuifF06F29JzUe9wMSVBEjnBg+yPfPYQs8sXRk4MwDzBaedj+5L9P4FYjTGGSC4ZWcLuN1Po/UWB6SgU2xKpJCpeMmWbPXBA3y5RT/yoYHAqBtPyBRLmx7597f/MIpCtEKzjeFWxahJVQl045DAJzFYa8f7sEVFw/bbfNcd1zwSQ5eYf4dGpAze0/0hcl5yXA6t2kZwiiHe0SEWjkYoucCKZi1zpDZF6zZz2sX9a37MFB1sXUGu4xyy7S4dgNXwpl0HwZBJpD+fJYg9pfrrpL6K76/Nk3Kk2J9lv3g5nDOaBCVGoOdXsKPoobXN09ov0grmnoKp0D5rrdtuR9XcC7PRRD8WiKo/aQZvx2qWQfofAv/CyGns9JrvZvg5hS+xnWjTX0cx7CBc9hKrroIu10yEOBukgTNPV7BhW0FFfofZGYCRoqbj+O+7ED5yeVoXJoyTklqCotAXQebG2HJxWp82GN6VJwD6/oTT+0nJ4uiXDSjMZoraYacn6m7RUsXN6wsvfYex9JVGzqtO8g5PJcj2KQRFfrTlmQiIyfK0d0lp1Z0hN562jVW4VN/eHMXUFohm5cNoOqBEJmhmNQFPnN9uJpK6201p99yZ3ljbZKRqP6ddRfvyNW7wC+tUksw13tzM08hRnIEZuF5Lh5GjeIUb5Pry2d4w4DpIHP6n3JFicJIqkeqgIT5EQ0xFvZDuMQJjmrVVW3EPfoOk0AWx+JvFwEsS0x9Ye6EHvL59vzFbpwnnRJg0qUP4IOz1XvKH5+1y1a35GChRxt2aW/WiAeZV80mqaaiLmSaXpQ00I6Lm8LMDVSsivZvQ7418E5+3lcjIv/LE0RwSSyJIknKwJCcf2ernugiQ1Ps7jnfHb2vv9grw7cjjf
 HZs2bk2e
 /4O6lSBhuZetl2HqpFGY8WYdtIRPwVGEHCQgnoeE6QPO8bKZ5FQ+GmSFiaxXO6aZKFyiawiPypXftvFvJPuon+cXd+zuvJFsbA1xZ/ZWJH6gtiH9gYuxnnen+XQbSJAV5CVU3ECsmOabPHqNfmcQVpcx5CFI99wY3ufT+RpC6Tgsvs5vBDKlE8RjXANqfi/PO6uu/cKfgZvZYwZIG1AAE/Ert6cAzMEcF2leDjPGmglBAO2IoHxTbEIZbja5RgrqclFs0IKVZPCNJ6Mzskk453AKNBYDduc8+Jb/+fhSCyFmZf89FEqFF64Qf02AVfgDmKyk1MIe7vzwxIXFk/lmJrfxrNEphzAHCHE470ogy72KdxsYd/04Uis1P0QjQEO31Ro6WieV2waPCPcuYAv1saJdUfVhM+v2zQpBw44IpPWuJgIEX86Rf3L8r3xb0Vaz3VxOV1gFeAPogoFbxLAkKugRpQRNGCMicJkSsHY9HlfYgwklYU1SUSnZMsVwhRQh6VxrKl5xsmsroTsrBlj51nzQ5FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Adrian,

On Mon, Nov 23, 2026 at 09:47:21AM +0000, Adrian Barnaś wrote:
> On Mon, Jul 06, 2026 at 05:33:50PM +0300, Mike Rapoport wrote:
> > >                                                                             I
> > > see that x86 has a lock that wraps entire process of updating attributes
> > > (including spliting and collapsing pages):
> > > ```
> > > spin_lock(&cpa_lock);
> > > ret = __change_page_attr(cpa, primary);
> > > spin_unlock(&cpa_lock);                                            ```
> > > As I understand it makes it safe already.
> > > However, on ARM64 there is a split lock (which works fine for spliting) but
> > > for collapsing at least on my implementation it is not sufficient as
> > > Ryan pointed out.
> > 
> > I think the lock should be at set_memory level so that set_memory callers
> > shouldn't care about the differences in arch implementations.

For callers to stop caring about the differences in arch implementation we
need this:

https://lore.kernel.org/linux-mm/20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org/

> I have recently got back to the topic, and I have one thing to clarify.
> 
> Currently the collapsing mechanism that is backing execmem cache, following
> execmem_restore_rox() description
> 
> ```
>   * Restores read-only-execute permissions on a range [@ptr, @ptr + @size)
>   * after it was temporarily remapped as writable. Relies on architecture
>   * implementation of set_memory_rox() to restore mapping using large pages.
> 
> ```
> is driven entirely by the architecture code. It has drawbacks, that could be
> addresed by passing some of the responsibility to memory owner,
> execmem rox cache in this case.
> 
> Arch code at no point is aware if the piece of memory it makes RW/RO, is
> ment to be collapsed. Every permission change can cause entire block
> to be collapsable so we need to try collapse on every run. We can probably
> make RCU-like mechanism to batch those events but still there is a lot
> of pointless runs just to find out we can't collapse or collapse of memory
> block that already have split operation waiting for lock release.
> 
> I was wondering if it would be acceptable to create a try_collapse operation
> in set_memory api that would tell the arch code "I will probably not touch
> this anymore for a while, you can collapse if you want". And call it after
> predifined delay from last execmem_cache_restore_rox call.

What do you mean by "last execmem_restore_rox"?
How execmem would now that an execmem_restore_rox() is the last one?
 
> From execmem side it can be based on the same delayed work mechanism that
> execmem_cache_free is using.
> 
> I have a PoC locally but it is mostly vibecoded and I have already
> discovered some bugs in it. But conceptualy it worked. After a batch load
> of modules it collapsed all execmem cache blocks in both direct map and
> vmalloc in a single run.
> 
> Before I craft a proper patch set I want to ask if it is in any way
> acceptable approach?

I believe we could drive the collapse from the callers rather than from the
architecture code.

Other options could be to make the collapses wait until there is no other
set_memory operations in flight or run a kthread that would collapse
everything it could.

But before optimizing collapse I think we should close the technical debt
of having 7 different page table walkers implementing set_memory APIs.

-- 
Sincerely yours,
Mike.

