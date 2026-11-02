Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9F5606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 23:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ojb3Czh8
Received: by kanga.kvack.org (Postfix)
	id 715DC6B05B8; Mon,  2 Nov 2026 18:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6516B05BA; Mon,  2 Nov 2026 18:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC1E6B05BB; Mon,  2 Nov 2026 18:06:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 298BB6B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:06:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 337AEA7ACA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:06:28 +0000 (UTC)
X-FDA: 85391714856.06.9C88DA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8241EC000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:06:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ojb3Czh8;
	spf=pass (imf28.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793660786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=adIUxbBUAhPoTEgVJ2ZdQQ0sIkUjRLbD7ye6beWxzTc=;
	b=iRG2IXXUZ6iwJgg6jVCSN33Ro6zX1kVKm7KGxUPo7xEsXBle9TVu6esyKfypd4M0QOVAK2
	qKfUrqX2Wb4FYB9AStdidOeVj0O92Z9tLo426zhT4hOaUmbStqPbm5E+tpvWj0va3ZVEPT
	1X/szaiRxjJquXD5/qANT1+LQp0NQmU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ojb3Czh8;
	spf=pass (imf28.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793660786;
	b=Z2SA3FqqSbKT5bE6m6SQpZy8buRZTZTxPuQ+OgQ+sF4qjsdwCE+nlnrgcfeUHsmkgdkOw5
	1FcBh1YS2QT/06ajbxOm/KaeV5A6CAP+639gAIitytre1Sv+vH2Z5JWovCkAYBKcuFfUtH
	6pz38vQVCNnerVcsrrUiGF6+s8p9d/E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA06040482;
	Mon,  2 Nov 2026 23:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1F21F00A16;
	Mon,  2 Nov 2026 23:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793660785;
	bh=adIUxbBUAhPoTEgVJ2ZdQQ0sIkUjRLbD7ye6beWxzTc=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=ojb3Czh8KMIoL/VvdgllPD/Rn4ll3vpd8bSHNaVcp9Gk0+6ToD6NDryr4AR11vpi1
	 XUxes3z4YCAm3nOVrM3z7fdOjZ+HdIJ58YE/s2Bvb3wYsSit40e6UpvA6SIWF3sftX
	 Jc3/DQgmwFDC5HZv5EWJ0QdlR3mDmib6RntK/oytFM9qo31kP5HL6/YpxOxRsFiyEb
	 YKTj6bbE/tAD2kBNwtfYEJPKAnI40oa2cJi9+zwtSQdFyTroKpSGQHcGuNo68X+NyM
	 mmbQ8UKB15V9j5BA3mPSpinaIx19MwiqSRLws1EJRYkagmH16Q9QXcp38qBD646Zhd
	 Jwbd2cKRXDFHQ==
Date: Mon, 2 Nov 2026 17:06:24 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Vipin Sharma <vipinsh@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org,
	ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com,
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com,
	chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net,
	dmatlack@google.com, graf@amazon.com, jacob.pan@linux.microsoft.com,
	jgg@nvidia.com, jgg@ziepe.ca, jrhilke@google.com,
	julianr@linux.ibm.com, kees@kernel.org, kevin.tian@intel.com,
	leon@kernel.org, leonro@nvidia.com, lukas@wunner.de,
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com,
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org,
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com,
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com,
	schnelle@linux.ibm.com, skhan@linuxfoundation.org,
	skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com,
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 05/27] PCI: liveupdate: Add helpers to preserve struct
 pci_saved_state
Message-ID: <20261102230624.GA1038787@bhelgaas>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102153656.1431701-6-vipinsh@google.com>
X-Stat-Signature: ccjqo4nsfjwj5cmnrow3zpm6j8oqghfs
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8241EC000D
X-HE-Tag: 1793660786-944012
X-HE-Meta: U2FsdGVkX19McwAZPMVtFX8qrqDiIW0522/gbL93NM3u/rGhB3lC10zoeE+sbU2BaL5hJOOPGhnvkHuiyXpiU3+qofBHhB3dP2GTcgXFtsaky3n4IKJyntBqoHDsC5Gn4dEMA6YXfHRT8XOqgel+k3LFSjOTg/YEdAGkK6Mm5HfsBnKi8ocRnGGDtTQAbfiP7msomir+FNNoaVuYdfMjbvko2V/77cjZoUCZudEIZ+MXuQYCk1523AHxxCLADKjvTtRzoAiL/ZQx0s60E4HOVUicgtod8N+Cmr9RH2L1jamQGHu84QVOMHFyXVtlD4MNDjK4YEoCcIXIvw85OsDgcyywni2eWneEO/MLSG8lbtOWLYF9TqqbYuqm+kNBTfrTulk5GcOI2JYRHBE3q0goSsn0hdFD+1E7klbdai5KbEADdwQwBy7m3Qef8GZb7B/AEjAujgXkccI2k8Wu2uB3WwZvagqSjtzXizhiTu6KP7wTVtNCLNDGsUadIIgMFLbfn0cZBxnZZmzSpac/TmvGv39Dh3OjajnMASyRUZQf027IunjBiOmjgktH8gjww34rVly+KT7xPov/NgGKh9/4DSrNJD6g6wA/uiSkiQ3oUIPObCtqBsrVIRuTNEbwLfrRWGDntDWvkRBPLel5SHJT6sKN/26uwPMEDBFrjEdBckUlpa/Q6fISLFHw3Hv4bLumy8ITHDLa2YwP8KJk14jQxhXBlv72TwNr8lED6n+p1SxtzcJd9/NopbfHS+ZpCu8j+GDeCkf2WmOt9ahlaPO6xbeU6iJljmNAPpml8t75GhpFDLN62mj1ULgZtZk4JKnogwhTLPCIjlnFP/KR/tg3UJiB2nTxCkbkT1GxN/81nLp5z5ekkQmm+nCehHvP82gTMd+12OEK6hknCNXs9REAQ+d1/R6j20fZL+rFmwGlvFVvkLIlFYn1SRTZ0g6r2BhKXpDoaRm43Ve0DK4SLpa
 1Y93IQ3m
 t2rpLfddQGxYYnQMqdcT3SbWGTILpxq8N8uUApyviRAGwbCqWmzeEywR7z1eSmOwA2ErRf/IBdbPsaM3n5jNXF3AgjLnBWN7gPdwDVk9yX+YjhEEwwkL4NRNMZwPr9oxdmTFcsekNqfTPwmVFFihEhIrWBYXxZj0DWufwjt3v2g6LioEqq77vJn+dwa4Q9f74Bx3lvAPj/D4oP/0ykQPVjCS+HigIk05IBCz+mwGhT88KHpv+i/RvTU/25ERRamcf/Mjj2m0IXioxWt3XKLSBkT1KaNZU+Ig5UaUHW8tefvUaEBAut3LK8qAWHwnvJeCd0WDjMb99W0dJ6fU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 07:36:34AM -0800, Vipin Sharma wrote:
> Drivers that keep a device running across Live Update need to hand the
> state they captured with pci_store_saved_state() to the next kernel,
> since the next kernel never sees the device in that state. VFIO, for
> example, captures it at first open and uses it to restore the device
> when the last user closes it.
> 
> struct pci_saved_state is private to the PCI core and its in-memory
> layout is not a stable ABI. Add helpers to serialize it into a
> caller-provided buffer and rebuild it in the next kernel with a stable
> struct pci_saved_state_ser ABI. Using caller-provided buffers allows
> drivers to embed the serialized saved state directly in their own
> KHO-preserved data with a single allocation and lifetime.
> 
> Validate the serialized buffer and verify that the saved standard
> configuration header matches the live device before rebuilding the
> state: the vendor and device IDs must match, only Type 0 (Normal)
> headers are accepted, and BAR0-5 and the expansion ROM BAR address must
> equal the current hardware values. This ensures that restoring the
> saved state cannot write stale BAR addresses if resources were
> reassigned in the new kernel. Only the address bits of the ROM BAR are
> compared, since its enable and validation status bits may legitimately
> differ.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

A few nits below.

> +static const struct pci_cap_saved_data *pci_saved_cap_next(const struct pci_cap_saved_data *cap)
> +{
> +	return (const void *)cap + sizeof(*cap) + cap->size;
> +}
> +
> +/**
> + * pci_liveupdate_saved_state_ser_size() - Size needed to serialize a saved state

Wrap to fit in 80 columns (75 or so is even nicer because it's a
little more relaxed to read and typo fixes are less likely to rewrap).

> + * @state: Saved state returned by pci_store_saved_state(), or NULL.
> + *
> + * Return: Number of bytes needed by pci_liveupdate_serialize_saved_state(), or
> + * 0 if @state is NULL.
> + */
> +size_t pci_liveupdate_saved_state_ser_size(const struct pci_saved_state *state)

I think pci_liveupdate_saved_state_ser_size() is connected with
pci_liveupdate_serialize_saved_state() and
pci_liveupdate_deserialize_saved_state().

Would be nice if that were obvious from the names.

They're also pretty long, which makes prototypes and uses very likely
to wrap in awkward spots.

> + * struct pci_cap_saved_data_ser - A saved capability in a struct pci_saved_state_ser
> + * @cap_nr: Capability ID (PCI_CAP_ID_* or PCI_EXT_CAP_ID_*).
> + * @extended: 1 if @cap_nr is an extended capability ID, 0 otherwise.
> + * @size: Size of @data in bytes, never 0.
> + * @data: The saved registers.
> + */
> +struct pci_cap_saved_data_ser {
> +	u16 cap_nr;

Maybe "cap_id" to avoid confusion with "nr_caps" or indexes into
"caps[]" below?

> +	u16 extended;
> +	u32 size;
> +	u8 data[];
> +} __packed;
> +
> +/**
> + * struct pci_saved_state_ser - Serialized struct pci_saved_state
> + * @size: Size in bytes of this struct, including all entries in @caps.
> + * @flags: Features a kernel must support to restore the state. None defined.
> + * @nr_caps: Number of entries in @caps.
> + * @config_space: The saved standard configuration header.
> + * @caps: @nr_caps struct pci_cap_saved_data_ser entries.
> + */
> +struct pci_saved_state_ser {
> +	u32 size;
> +	u32 flags;
> +	u32 nr_caps;
> +	u32 config_space[16];
> +	u8 caps[];

I think it would be helpful if the names of "config_space[]" and
"caps[]" hinted at the connection between them (both are in config
space).  "config_space[]" by itself suggests it's complete, which it's
not, so maybe there's a place for "hdr" or similar in it.

