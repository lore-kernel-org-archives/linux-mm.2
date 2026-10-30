Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE091606A325
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 19:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jR83Kb9q
Received: by kanga.kvack.org (Postfix)
	id 0892F6B05B2; Fri, 30 Oct 2026 15:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 039CD6B05B3; Fri, 30 Oct 2026 15:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C296B05B4; Fri, 30 Oct 2026 15:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD3E96B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:03:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 586D9A7AE6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:03:23 +0000 (UTC)
X-FDA: 85380215886.24.D5A5B88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4FF741C0011
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:03:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jR83Kb9q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793387001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ez6NwxCX3bhjDqnSlRsdUj2bvOIZ+33wXUFtZScIV1g=;
	b=ZSn/PtK8QdMVl1aXBpve4rWoJDPn4KeJKJ69WFPLyI6xQ/tpW+a92y4LjARjTjg2YjfkhI
	XMDXlvee2dM/B2o4NL5qAJuHgCMfJSD9Bcmu11J8r7VZFjcNKrLcdi+ytgtnQkmBGRMIAe
	FY3tcnpzCg/z0F1yaWXzadh1rXwzlNg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jR83Kb9q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793387001;
	b=QFusCwn0AY2oAfBmvTJklHOM4JAjVgW02aTu/GU81oYk4uurL+cZfWqQBSaFnaKEDyb22k
	MQeDCgWSXUIOfouOsee/I2OgF9V6bdUz2n4H+UMVCWzqfDUVLhfDMAEmugA55zNpBHS9E3
	nz14h8VKer66oViaXfPnwJSS9Ik+LZI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B1DB43C71;
	Fri, 30 Oct 2026 19:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D561F000C1;
	Fri, 30 Oct 2026 19:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793387000;
	bh=Ez6NwxCX3bhjDqnSlRsdUj2bvOIZ+33wXUFtZScIV1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jR83Kb9qrDLc0R4usVOoKB7Wfomia0GqfF81Td+WbSHwwVFRLIPdKI0/vKgHbGgWb
	 P1USucvboR+nddAxF/OZRMK0Ew55gkfE1rvvVBGUVExEc2cV8sn1eu2xRsK9P1spXk
	 yJ9adP/RhRcn4iySwKESga8MO710jC2KbtLMkP6FIVF8zKe1ggfp4QqKW4fMKAsQA/
	 Yv4GQKGycK1FLwZ7Iwocu8SdRhjktGPMiUryhwcZkZ+QdtHDmj2WqfBmBfEn7klP5i
	 qUl34fTmuMFxpxGecnNqx2fq5PohsF6Onpef8NtsZOeWT9wJuU8MwdIbKZyq/QQpIj
	 KkXBSPPmT9bDw==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id B9037F40068;
	Fri, 30 Oct 2026 15:03:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Fri, 30 Oct 2026 15:03:18 -0400
X-ME-Sender: <xms:9unkaooeMLGQ8g__Yi_Sp3XCPOy2OpomnXvZRNPjlr1ULv5uB9nIzA>
    <xme:9unkaheo5QsXe81j1maoi8DP5KLFJLNFlATKcO2b6F5oDTLY5AKD_UwxA0fv8yZiJ
    nWfUMVF9DG1EdD1UDuhoyLj0zuzqe0PCqIkY6fOJnUJwIgNMMq44w0>
X-ME-Received: <xmr:9unkav9EdI6EqdoQ0dmgg7l9dskWNX_tVFTPW2QAk-RQhGKOZs0ekdyqVd854PweoGpCjv46HP3pkUa0-qj3WXFlo9js3z3b>
X-ME-Proxy-Cause: dmFkZTFGOr8QamtD/idwG8XBnzFAf/Ml7EAwCH31rnH8844AjLaVjcYoNBFy7nItSr7/1R
    lKLHkptekXrYmhAKtgQ1Z+R7VAqLBCvvhIKid69nwHnmkXXVXREiZZ8oE4ml2ZXua7p2aW
    mQmAcy/zMr6ozkc6UBBgKuOc54G/Nq6wmDswdE2iZ0oNX0nyv77LixT1rJuAK86uLRkCrb
    zpq8drx/483k+MkNQIfPcPZt8SIm44QxOvs9tyx1C5HtY485ysmDgaVxenlJAEBQO1QXf2
    BQP+bfx7YLCr4UXJwZyyw6DeHKCAymUkdVUdgSFkV8FTLEwqfnvsgNQ/CBKWOkZyfPJpAO
    Al4yqBIi7gDBRnRpWOZHTMHspW3NbHnz3tfkJ3uE049XnujAFSjZJFrNTUoDrSiUfhUocU
    kbq/qJbDFNqTeqiE6KWjoGMgjRVFA6SGNk/kf8Q+8QqSShsOA6RZdm4Dq19laUOOpJLUel
    nldBdI3ybTOTjroLAAHFHhnIR4AdGLgsir3ATgNlzUnP2589vKropgG7sOAuRtGqomh9XH
    E9AlB5DHJFs34LLa/aIuFUBU71dMXYbEzW3vHDtoFyV4WEL1UiyAwRUUUELS6S/jP3YuB/
    cnPbmCCSGKyWLaYixZ+A7AgPcyZ9Wej6qrDumo8qHFJv74joRgAvSZRQfiNg
X-ME-Proxy: <xmx:9unkajaqVwjO98a_kB8ukEVY-GkrneZIY2guhFSvWSHT8m8DQihEnQ>
    <xmx:9unkai2TplNQ0-PjlG0U0l6N92k42R7ab6SMaKsynSZLjwjJEH8tjA>
    <xmx:9unkas1addTZKN7Pb3QzqxS_p4Mo4__0BoaiggYCFODftputQTsSAw>
    <xmx:9unkav5Gm7dSWC8H-tw447T8lU9EBQh6SLVRNXAvrj7gB9nroVFb4g>
    <xmx:9unkar0o4mYr0XXO4IoznNFiFH31Ue39lsZ465Szl1SAs7-NHZB5_p2S>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Oct 2026 15:03:17 -0400 (EDT)
Date: Fri, 30 Oct 2026 12:03:16 -0700
From: Boqun Feng <boqun@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Yury Norov <yury.norov@gmail.com>, Yury Norov <ynorov@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 1/2] rust: add a wrapper for the `nr_online_nodes` C
 function
Message-ID: <auTp9HYxHde2IONT@tardis.local>
References: <20261030-cpu-helpers-v4-0-a8d840d34837@kernel.org>
 <20261030-cpu-helpers-v4-1-a8d840d34837@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-cpu-helpers-v4-1-a8d840d34837@kernel.org>
X-Rspamd-Queue-Id: 4FF741C0011
X-Stat-Signature: gczho6fp9b7pfuhpxaqjzzmtetqsujug
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793387001-448315
X-HE-Meta: U2FsdGVkX1/iKZOk/FXlcXDsW2qp60x9gLCNq9oV8oWxp/8x/mt4gOmfJ+w7r0/gRArX7uGRWTY1TOQcKEJKe78ErIBl58r2Ost+ElDNp9qfDzRKaLAgRI8eYmOefagpERpg3LbuWDL9AwXLQHkpn9IdP1XuuCIZ/PcRh95mNoxQSlI9pVsFtG3V6SsEHTTYLIq6RG+1GIkEQwsutR9U9Rhp45WmZk0FEXb2fTQkA1t0B7KmNmBH1mlVEEl1rGBOmcGBElPSFpfb/qyvCSpVHCUpLcKcxnWCVvJlWvCXy7D1Twxk2d8rcqR5pq2+UdPQCSkj38nbpIUEWRvqJ5mmbZcrskW+icC4yE3z0JB3LqrBukfJa6ucBOqGmqBHgnzoYewE+0yzA0nlK1UaQPGs8i0qFoVeM5cu+ZrsRao7Kj4gkz6hatg4cilpLVVBX9MlqzjXkQY0o6Shs8cXpbl+vKZopTNAKGk/k9WTjnRxO18/wC+vRFKHj+24+lz6GXW4ZoQcpUFq5iiMFFD7kX3Dhp0UrvYlfAXplhfb5HPEd7aFLYuph6cLRkYmdys5YhhZ2nObBHfMz+b7S78MSKGf4rPP4hJUNqoKl3UtlU3uqq/sIXqPiha+s/9k4LTDj3kgc3SUXxVywfV6OJlgpmv+iNBVxLywhnKfYnssBK4fYeuP5qoRL7ofIRth6LI3aGtl9AUKN9LDaJvVkkFnxk6+yKOtdX0syxrTxA9BMCl0ov8vxlHEOV6FxtvhQynr/wGZT1WMrNDpxaiZC9vW6H0XES8iNpdRweoNVd5W5/Jm/DTOrtJT2gzDQ/JG7cjNWhw6Z9OrpOiPVrH+B91Uq2McO+5v9Z5OHl/0omTCgPRO1j+6XqjwCkuPoZZd5AuCIAhlYp/AmuBRfKyGBiIy1OIfntnXFtWg8l2JQqQk5AoZl1fCq+G4zwkEErwUjkh/NpB6XZOdkxxKphswxLSZOk+
 ceVYxduH
 +km4bIHScD/jnq336qEJst+x4TzJ+AHS3YNq95JDTKAn92CujEdAZQPKvHYmikx/d83SwoHiFF/uuRmNgNs+X0uSjXmEZ3UPmJzUzUNuR6jM3hx89xp0jhYwLugBEIwxn3wVGFkOdeEdNnzSNHUaDsmmICtJBLPAEBcvxbPOU3gUtFgaLcHI21bvCd1qZfokXRF9rZc5mtvqibW3112uk6yLglDDCeEy23ZX7WOZ1G9CgykU3q+HqT1lEBG/cOZXrN3ahrbIOxp8xOCJb3HYij2LOm5F4AcYcfpzYOEOSSqQaIia9BjQ4fdls4Us/d1i/Uh9lwtEgjSGqdMujpADbGl7qKCMhIUQ9qwysWWALSK9baUR3ZNEiRBo8bUIpO+nJQUveVHPoKTy8IDILCYFrlsXv8CTsblSWekZIQ4k7/DShh9N9/PcwGIT/PSxvWppK0YsHQ6XQWHJSosdyZdy1dkC2rwQl5eFKieColOuocQWp3DCkB4S7/KH5dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 05:08:03PM +0100, Andreas Hindborg wrote:
> This function returns the number of online NUMA nodes.
> 
> The wrapper is needed by the Rust null block driver.
> 
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Reviewed-by: Yury Norov <ynorov@nvidia.com>
> Assisted-by: LLM
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/kernel/lib.rs  |  1 +
>  rust/kernel/numa.rs | 29 +++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index 4d5c96ddc49c..a7b1c9cf454f 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -105,6 +105,7 @@
>  #[cfg(CONFIG_NET)]
>  pub mod net;
>  pub mod num;
> +pub mod numa;
>  pub mod of;
>  #[cfg(CONFIG_PM_OPP)]
>  pub mod opp;
> diff --git a/rust/kernel/numa.rs b/rust/kernel/numa.rs
> new file mode 100644
> index 000000000000..164e622d325f
> --- /dev/null
> +++ b/rust/kernel/numa.rs
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! NUMA topology utilities.
> +//!
> +//! C header: [`include/linux/nodemask.h`](srctree/include/linux/nodemask.h)
> +
> +use crate::bindings;
> +#[cfg(CONFIG_NUMA)]
> +use crate::sync::atomic::{
> +    Atomic,
> +    Relaxed, //
> +};
> +
> +/// Returns the number of online NUMA nodes.
> +#[inline]
> +pub fn num_online_nodes() -> u32 {
> +    #[cfg(CONFIG_NUMA)]
> +    {
> +        // SAFETY: `nr_online_nodes` is a global variable that is valid for the lifetime of the
> +        // kernel. The C side updates it with plain writes during node hotplug and reads it with
> +        // plain reads. A relaxed load is the Rust equivalent of `READ_ONCE()`, which is the best
> +        // we can do on the reader side.
> +        unsafe { Atomic::from_ptr(&raw mut bindings::nr_online_nodes) }.load(Relaxed)

Just so you know you can use `atomic_load()`[1]:

	unsafe { atomic_load(&raw mut bindings::nr_online_nodes, Relaxed) }

With or without this:

Reviewed-by: Boqun Feng <boqun@kernel.org>

[1]: https://rust.docs.kernel.org/kernel/sync/atomic/fn.atomic_load.html

Regards,
Boqun

> +    }
> +    #[cfg(not(CONFIG_NUMA))]
> +    {
> +        bindings::nr_online_nodes
> +    }
> +}
> 
> -- 
> 2.54.0
> 
> 

