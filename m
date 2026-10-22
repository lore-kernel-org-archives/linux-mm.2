Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65801606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=collabora.com header.i=deborah.brouwer@collabora.com header.a=rsa-sha256 header.s=zohomail header.b=DlE5AX0E
Received: by kanga.kvack.org (Postfix)
	id 65F996B030A; Thu, 22 Oct 2026 19:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637E16B030F; Thu, 22 Oct 2026 19:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E4F6B031A; Thu, 22 Oct 2026 19:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37E546B030A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:53:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB10D160325
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:53:28 +0000 (UTC)
X-FDA: 85351916496.15.8D82509
Received: from sender5-op-o11.zoho.com (sender5-op-o11.zoho.com [165.173.182.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id BD1061C0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:53:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=DlE5AX0E;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf18.hostedemail.com: domain of deborah.brouwer@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792713207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZVFc2cY2YdRXjDiQkdwMYAg1zQFmPzyWnIcVt7gubM=;
	b=rwUzjgSB3haWibNdFBztipjbE8hPg/qN4gF/CWQFbn1OdVvpaEtP6XzmJfJaX/UmSZofsp
	Uxe+W8I6W/1gboMf735P2NueqG4I14HMGegyKbJJ+6v4JxuVDa3hI4h5E/2nRE0mO6HuBk
	scuz9OXxrxwm+5VHY6VHBlPCaVqSAcE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=DlE5AX0E;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf18.hostedemail.com: domain of deborah.brouwer@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792713207;
	b=SbjADR/fcLDaTISMNJHmssP0nkkTTbKCX2dluqSmGkB87OPIrhB4O6Yd6EI5JvC6khN9hv
	lH8TRSvB0ZDf/l9JD2kEX/W8rSyYCh2ljoQP6kcHwVZmXCocPgV2GDRYij/7oi8Qqh63S1
	R2GI5/QatO2IEhScke6NzGEzh59iV0g=
ARC-Seal: i=1; a=rsa-sha256; t=1792713190; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=USsdMuU5gMmdKZAKLj6NLOnUxRJnM4QSY1B11nzzY4L1EyIng8Vwyn6fHNtwax5k0qXlTIOv5+35ydqbHPlqPxrxi7bsQineaZDPQH9DdT/I0A3I2PKmyMYD9kF/726Pxj487v/KAZFX5ZCJ5tIwUCyETV5tWl+1bdODBVaycHk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1792713190; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=XZVFc2cY2YdRXjDiQkdwMYAg1zQFmPzyWnIcVt7gubM=; 
	b=MbLhPZWuQeuUjHbNqy673eyDyO+yGb1zmqZcoF/feyV1ZcEI5BP/LbKjQ0VfGae2gn6wwCpD//dw7iIdIJP5MtqiojDvAS6H/Q1ixEQI/AR5nk5pW2SHQN7Qa1sXUuGnckDMRMre+ETbODlIdLg/I27ANEQpJWE8op4qdbjc96k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792713190;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=XZVFc2cY2YdRXjDiQkdwMYAg1zQFmPzyWnIcVt7gubM=;
	b=DlE5AX0EJFn4+qNw7TJfzSEARTLOr+0xnH049vabN+TeMo7m+gjRnq+GOfyedonw
	6jdQcP40bT46n4YNFimPPDK5k7gw91j1nW5O9+88r9/dkxpMGYkjuNOT4MniYXMst7b
	bHzd0Z/HLqnpV+zwqzsH3arHsPdqA6fHVhM4VEDI=
Received: by smtp.zohomail.com with SMTPS id 179271318893732.044990374067766;
	Thu, 22 Oct 2026 16:53:08 -0700 (PDT)
Date: Thu, 22 Oct 2026 16:53:07 -0700
From: Deborah Brouwer <deborah.brouwer@collabora.com>
To: Ke Sun <sunke@kylinos.cn>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, Alvin Sun <alvin.sun@linux.dev>
Subject: Re: [PATCH v4 02/11] rust: mm: add `task_size` helper
Message-ID: <atqh41vrlC4xVtaj@um790>
References: <20261020-tyr-ioctls-v4-0-704de77da223@kylinos.cn>
 <20261020-tyr-ioctls-v4-2-704de77da223@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020-tyr-ioctls-v4-2-704de77da223@kylinos.cn>
X-Zoho-Virus-Status: 1
X-Zoho-AV-Stamp: zmail-av-0.2.13.1.5.4/292.705.96
X-Rspamd-Queue-Id: BD1061C0004
X-Stat-Signature: zwxtegmeek4ju1x8qq9z7rxacrsxtsxf
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792713206-864275
X-HE-Meta: U2FsdGVkX19DBFGdax9KhaHe7WtWysy99I6VI9GpM/eBCMlrS9kVPt2+JkZza0DlUiAlzB6RnCdx9sjl8NtqjGoR+4BpSja3w778snqY8cofy32bk3OpiKSl8nxBXIuFAMOGkXZwKXNdy0yxXqPBpha0w1uVwmsWgDzZL8v3eGYA+uBYXg7J4+tGmgX5IcHkVcdgqU80SoYuDih2RIY7zNXCwmgK9Li1eNKXBND7yV93nSYDRFntOF4wko/QeIZUIvTNZU8BtLjqpwb/IbARNjyFg21V6jnS4/UGCbVAbcteO6TsQIYEJLEy4YOnSm+RvCQ88sF7GHudjAt+j6NWcTR+V4CcTUhFX4Raz/s2RYL/6Kre68Zi4fN3DSr7U+xqQr3QTwBq3dh2K27LgsDYoSyDO6xVbkpaYqtf5qYefs1YBJeI6CLnCtxrKLCaqnpESpQK9eaDSufccueVk65INmOs5b3fFVpEmBd9DhfqQvfCIk75ObR2Mfu55NwVaJEtCLOcx6e3iieNRkT0s6zHIpdAuy0Uio5pzmZGMDHuAa+M47PCzwY6I4u2Bf0QxrqRg5BOoO+rqFd8s4L4YW7/K3IkgQm/2GYQeh1GCNkC3A4d+azN8UV13u5b5EHZVDdLUQgbdLS0tplD4QEz3uabr7oiT/zzqoi1gsTajj5Lv2HQ4CMBarqkoWoEUkPp+YbFSrt3J+9DdCJJPuP2BuzBC2D+0R+lFQ4Ozoz23cmLDulQCH0eSH3LF9CTgslRMBq5mwSZNnBaCt4hcuNh5P3IyQ9Gu1gxLLoOfJuK7HPkvYdeYw+ggYvpVpYtjCxkbzORah6Sfgik9khPbDmBf9UqrUQ67RJ+08oEB9qLyG3m71vLmk/QMeqd4jMNnJ/nd2lCy2FzBdrq1T8LPIEdrmJynQpNe1Dt8Xe03x9y59pNRZL2w93D89tvTWbLhhu7TEr+8FDOuPRy0OJcSmwjrqr
 o40FX660
 B/bTKNZb48NtKWTi37O85Q2cmZA4K5JhTWNuVmkNe7TGf10ZJb6Wt+sbPFYZH0lcUbT9Boy6uAbYx0raW7idMi0ZJvM2pgL7pLOdrC1LbOAZ0WPbH6JltiW9GBcykHD8/JKnmQp805kFThxwgTb1EdQEtlIJNQMJBO+8vfbW7ld9s/nXa1HqIbZLOlBIMvOaorrS3OOPyjoyD4Jjtg4rzKdhlApSiVXklmy4rT1C37y8ChDaJCPliTFVRQve7zvztADzI2p/0tBpRfa98I/Qmn7jl4BDKjXBn5eSOjOgDxCDRwltR2r43SoLyQvKSAjxxoMx7Uw5CSPdy/TaexlYAmjhQic2n7jZtPRDg1w5wuqrQDh7kQ24pS1qNsxJ1DwMLwbDvBgriTvuOS99L2Bd7QbRaumw+tPAfumehMy6AM6gaGWxuw42nQ5sIKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 04:25:19PM +0800, Ke Sun wrote:
> From: Alvin Sun <alvin.sun@linux.dev>

I was testing Tyr's auto allocation for the user va range,
and was surprised to see that mm.task_size() is always returning 0.
It seems like it should work since it uses the task_size from
struct mm_struct, but it doesn't, at least for me. 

If you look at tyr-dev, I think it would be better to use Sami's approach:
  428d71932b6f rust: task: add task_size()

Sami creates a task_size() method for CurrentTask which is our equivalent
to the `current` global and then you can see that task_size becomes much
more clearly the equivalent of "TASK_SIZE_OF" used by panthor.

This approach also correctly returns a user va range when Tyr has to
assign it in my tests, so let's switch over.

> 
> Expose the task's address space size. It is used by the Tyr driver
> for splitting a VM's GPU address space into user and kernel regions.
> 
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
> ---
>  rust/kernel/mm.rs | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
> index 4764d7b68f2a7..d2dfbb7d43972 100644
> --- a/rust/kernel/mm.rs
> +++ b/rust/kernel/mm.rs
> @@ -149,6 +149,13 @@ pub fn mmget_not_zero(&self) -> Option<ARef<MmWithUser>> {
>              None
>          }
>      }
> +
> +    /// The size of the process virtual address space.
> +    #[inline]
> +    pub fn task_size(&self) -> usize {
> +        // SAFETY: `self.as_raw()` is a valid pointer to an `mm_struct` per the type invariants.
> +        unsafe { (*self.as_raw()).__bindgen_anon_1.task_size }
> +    }
>  }
>  
>  // These methods require `mm_users` to be non-zero.
> 
> -- 
> 2.43.0
> 

