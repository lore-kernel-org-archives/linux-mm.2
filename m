Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6BB606A329
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 07:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EaM7GVz8
Received: by kanga.kvack.org (Postfix)
	id 3B0E06B0B14; Fri, 23 Oct 2026 03:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362056B0B16; Fri, 23 Oct 2026 03:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251386B0B17; Fri, 23 Oct 2026 03:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2A146B0B14
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:44:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DCB18C02F9
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:44:17 +0000 (UTC)
X-FDA: 85353102954.11.97BF3C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 23FF0A0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:44:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EaM7GVz8;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792741456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wy/cnaPswmms/QpZfcVOeHijhXMXPHn20ADaK91xPcA=;
	b=Cfc5RaRLiu1g9kBF7Rv/rn16hFJmq1qt5//yShBNbi3rpY6ukaiEdu4UGONvsyUQZ4QbDM
	Nb617FGWroN4473Z89AOWvgw9hLHIO71fofsG0ObtkrsidEWdouXUagI4h+Di1Ws7m9agV
	xTcmCruTTL9ChdW87wcc1aPmiBd+TmU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EaM7GVz8;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792741456;
	b=srSjCf+ukrHRN5wXnjUqAz1or8HEhP8xCPBhWrP10XVwNCDaEt3Wj6uGTwz9SWB+k1kRfQ
	1hMEL/CJ0RQzS8t8sNu3+TG2/mnkXyMXARsf6Omh4ND4AmxjA2oUSBcQKjcUf+tvHcGGFV
	aKryMTSgBvd7NSIgb33wiOMwqQr1TUA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47AFB42B85;
	Fri, 23 Oct 2026 07:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9170D1F01825;
	Fri, 23 Oct 2026 07:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792741455;
	bh=wy/cnaPswmms/QpZfcVOeHijhXMXPHn20ADaK91xPcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EaM7GVz8N1F1WL1rJOnrhPXJUtKGkqsv14MRU42ie3CqopgX3LNFxUDnl1OPNUi/e
	 2iQPCPAmrugokeUqdjjGnxoE/8npZif6jkFURSIYhrlahltUYFVTdLrUtWmi4bJDt4
	 uJpg0nOqXHeMjeyusKILIH3Cl4Mf3vGvpiVoTnLCyKCJvnhkOfk8IhqWDgFcrVZDsw
	 RQJc+E3xcDPh7iuKo7qjMm+aQPiRzX97cIhkWDsUcyao4CJSpPFEH+7iNFyZcmmnZH
	 r3znD2zes+BCcnM/Q+slSfn7Uk5g9JQYqOi58zhfrrPLbNKPn/9s/EmGcuM+9Ol3+7
	 YAzLqgDZtmCpA==
Date: Fri, 23 Oct 2026 10:44:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: tarunsahu@google.com
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	David Matlack <dmatlack@google.com>, jgg@nvidia.com,
	robin.murphy@arm.com, loganodell@google.com, oupton@kernel.org,
	kevin.tian@intel.com, alex@shazbot.org, dwmw2@infradead.org,
	pbonzini@redhat.com, seanjc@google.com, will@kernel.org,
	Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/4] liveupdate: Rename handler compatible to name
Message-ID: <atsQQcUiVhb9KXWZ@kernel.org>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-2-tarunsahu@google.com>
 <CA+CK2bC_wc4LxvHe0TREbBP7esYW3pcMNtkGK-kqvf6MyvOh2g@mail.gmail.com>
 <9huzik2u6hs5.fsf@tarunix.c.googlers.com>
 <CA+CK2bDyk=F7W3J=q3pKCjsr2wy_PLdgqgu+ywp0F5HL=VoMpA@mail.gmail.com>
 <9huzld7q4zjz.fsf@tarunix.c.googlers.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9huzld7q4zjz.fsf@tarunix.c.googlers.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 23FF0A0003
X-Stat-Signature: detfkzqujd6ct4ghcwiyzmdccug8z3pj
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792741456-242989
X-HE-Meta: U2FsdGVkX1/4hm4jG2v9cCV/51AB23o3Ydp8ejxnW9+6c4lSx8JXxtoR9yNiJXfi1bE766nsZIkozBBwY+LEFs8e0CL/kdan/7ZAqC6Uqb0ro+eEXkjIniDj+5LDya41Wp4ZLkRNAx1PbS1JzzJlGfPDqmJpMi/cu4RjKLKLbvo3efZRATLV6Ys2Y46wK5qUFvAv8g9c/QsQHUoAkkZnIeJyniOugNvKkJjDSsxg19CRKQQAwC3LRDkHEVh6DdpIsSqZEaQkghavuyJaHTLxcuPl7ioD7Ldw5xc+bI97qAvEmFcQn9uiBNuWLQdQTzX6lojZLYT+GRtT5tdzErkoBmVlnVIRXgWPN47l/SE/9iV7g+7YbeEXz9MUBg/oxbC0zew6iD39RIecjM9bF0gTUGZ3OukBwd+5J46umoAelkLdZe1vc2HOX55XmwtmdZJrcOEP8KFSHHYK6ev36Ib+iKJFvmn9BpT0ZLcvB6nRCxNx3ZHUlkRnQdxRGYd0ELjJk3GkTtrIjGDr5qrnMrVQmwcvPsVvdd7gyZt9bsMScMtGv0x2SvYAGPzScIA5hEngBEHJ1nKaCMOWdgtnqSxKsMEHE9Bi+tfgdqHOvz5zT91vcXNfftWjqeQ0CoUYHKawy9xVtmoJJgJcCiU+O2MBf6cZMz+u0PIbW4xMW0/Ob4wdozjvZ6Xu7An0iLUuxOARa9Iy35DZcD1LCnnINVFpj5HM5Ms7J6EnuYr3twBmWsAelUNbu7OMCVcH2Wgvr6kXdzozAeTJ68YRBtE3wxn965mPYdq7VUZh5oqTlI4skSrMbqHCc650g5+rFehSKPLQWcrHrGoW3K34sqjgSoTkPq5PRR801kQN9cWzk5HqD/860Op6okb+ouAjHPc3CbYPnBbUxY2+NoMEQ4Jf7B9/n5uau69PNg2DW6sx44oB8nPmMES4zBQfgXX3XDk1rD1jgfNhTXe6rPGKoidBkfU
 VW4Ikc8/
 oBuEp1Y60SKHS5mO96gxrckc2aakfwh3IaHGvR92AAGoY2cecOxPUsbJ1zHxWw/+xUq+wp3+nD2rtLW1xvd2bGTKbfN8ATeKpBeDG1YsVL/7Od97EziH5fo3iahA9z2nuFIC4o9hjGKXOVQ0cTbJnaBanvEb6h0XcKswiKQ7mpJxyIWaaj+Ab2gQoh1YJA5Xl9kooCwESg6Laq9okaO6J9TASZLtOvz5+zthQXu9CiZdCpTIbEv9xQHUqfw0SWB3oyKIFqOfYMlIcrCue3gD7WktIFyNhCDX7JQeoaf+/aEYQrQGm8lzysn5R510j3esDqxUfP7egzZkFaJZZ88NG999yqvJAY4qUOSkHM7yWdMKNo6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 07:35:28PM +0000, tarunsahu@google.com wrote:
> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > On Wed, Oct 21, 2026 at 2:16 PM <tarunsahu@google.com> wrote:
> >> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> >>
> >> > On Wed, Oct 21, 2026 at 11:25 AM Tarun Sahu <tarunsahu@google.com> wrote:
> >> >>
> >> >> File handler and File-Lifecycle-Bound (FLB) identifiers name the
> >> >
> >> > Please use FLB directly, no need to spell it out.
> >> >
> >> >> registered handler or FLB rather than a monolithic compatibility version.
> >> >> Rename compatible to name across LUO headers, structures, and consumers:
> >> >> - struct liveupdate_file_handler and struct luo_file_ser name field
> >> >> - LIVEUPDATE_HNDL_NAME_LENGTH (in include/uapi/linux/liveupdate.h) and
> >> >>   MEMFD_LUO_FH_NAME
> >> >> - struct liveupdate_flb name field, LIVEUPDATE_FLB_NAME_LENGTH,
> >> >>   PCI_LUO_FLB_NAME, and LIVEUPDATE_TEST_FLB_NAME
> >> >>
> >> >> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> >> >> ---
> >> >>  drivers/pci/liveupdate.c        | 10 ++++----
> >> >>  include/linux/kho/abi/luo.h     | 26 +++++++++----------
> >> >>  include/linux/kho/abi/memfd.h   |  4 +--
> >> >>  include/linux/kho/abi/pci.h     |  2 +-
> >> >>  include/linux/liveupdate.h      | 18 +++++--------
> >> >>  include/uapi/linux/liveupdate.h |  3 +++
> >> >>  kernel/liveupdate/luo_file.c    | 45 +++++++++++++++++----------------
> >> >>  kernel/liveupdate/luo_flb.c     | 16 ++++++------
> >> >>  lib/tests/liveupdate.c          | 22 ++++++++--------
> >> >>  mm/memfd_luo.c                  |  2 +-
> >> >>  10 files changed, 73 insertions(+), 75 deletions(-)
> >> >>
> >> >> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> >> >> index 51695782ed42..3cf01d7d615c 100644
> >> >> --- a/drivers/pci/liveupdate.c
> >> >> +++ b/drivers/pci/liveupdate.c
> >> >> @@ -424,7 +424,7 @@ static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
> >> >>
> >> >>  static struct liveupdate_flb pci_liveupdate_flb = {
> >> >>         .ops = &pci_liveupdate_flb_ops,
> >> >> -       .compatible = PCI_LUO_FLB_COMPATIBLE,
> >> >> +       .name = PCI_LUO_FLB_NAME,
> >> >>  };
> >> >>
> >> >>  static void pci_liveupdate_flb_put_outgoing(void)
> >> >> @@ -667,13 +667,13 @@ static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void)
> >> >>
> >> >>         /*
> >> >>          * Live Update is enabled and there is incoming FLB data, but none of it
> >> >> -        * matches pci_liveupdate_flb.compatible.
> >> >> +        * matches pci_liveupdate_flb.name.
> >> >>          */
> >> >>         if (ret == -ENOENT)
> >> >>                 return NULL;
> >> >>
> >> >>         /*
> >> >> -        * There is incoming FLB data that matches pci_liveupdate_flb.compatible
> >> >> +        * There is incoming FLB data that matches pci_liveupdate_flb.name
> >> >>          * but retrieve failed (pci_flb_retrieve() returned an error or LUO
> >> >>          * failed to acquire a reference to pci_liveupdate_flb_ops.owner).
> >> >>          */
> >> >> @@ -998,7 +998,7 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_is_incoming);
> >> >>   */
> >> >>  int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
> >> >>  {
> >> >> -       pr_debug("Registering file handler \"%s\"\n", fh->compatible);
> >> >> +       pr_debug("Registering file handler \"%s\"\n", fh->name);
> >> >>         return liveupdate_register_flb(fh, &pci_liveupdate_flb);
> >> >>  }
> >> >>  EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
> >> >> @@ -1009,7 +1009,7 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
> >> >>   */
> >> >>  void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
> >> >>  {
> >> >> -       pr_debug("Unregistering file handler \"%s\"\n", fh->compatible);
> >> >> +       pr_debug("Unregistering file handler \"%s\"\n", fh->name);
> >> >>         liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
> >> >>  }
> >> >>  EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_flb);
> >> >> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> >> >> index 288076de6d4a..5fb2f46425d7 100644
> >> >> --- a/include/linux/kho/abi/luo.h
> >> >> +++ b/include/linux/kho/abi/luo.h
> >> >> @@ -39,9 +39,9 @@
> >> >>   *     Multiple blocks are linked via the `next` field in the header.
> >> >>   *
> >> >>   *   - struct luo_file_ser:
> >> >> - *     Metadata for a single preserved file. Contains the `compatible` string to
> >> >> - *     find the correct handler in the new kernel, a user-provided `token` for
> >> >> - *     identification, and an opaque `data` handle for the handler to use.
> >> >> + *     Metadata for a single preserved file. Contains the handler `name` string
> >> >> + *     to find the correct handler in the new kernel, a user-provided `token`
> >> >> + *     for identification, and an opaque `data` handle for the handler to use.
> >> >>   *
> >> >>   *   - struct luo_flb_header_ser:
> >> >>   *     Header for the FLB array. Contains the total page count of the
> >> >> @@ -49,9 +49,9 @@
> >> >>   *     that follow.
> >> >>   *
> >> >>   *   - struct luo_flb_ser:
> >> >> - *     Metadata for a single preserved global object. Contains its `name`
> >> >> - *     (compatible string), an opaque `data` handle, and the `count`
> >> >> - *     number of files depending on it.
> >> >> + *     Metadata for a single preserved global object. Contains its FLB `name`
> >> >> + *     string, an opaque `data` handle, and the `count` number of files
> >> >> + *     depending on it.
> >> >>   */
> >> >>
> >> >>  #ifndef _LINUX_KHO_ABI_LUO_H
> >> >> @@ -84,18 +84,16 @@ struct luo_ser {
> >> >>         u64 flbs_pa;
> >> >>  } __packed;
> >> >>
> >> >> -#define LIVEUPDATE_HNDL_COMPAT_LENGTH  48
> >> >> -
> >> >>  /**
> >> >>   * struct luo_file_ser - Represents the serialized preserves files.
> >> >> - * @compatible:  File handler compatible string.
> >> >> + * @name:        File handler name string.
> >> >
> >> > We are renaming from cpmaptible to name; I am not sure that is
> >> > necessary. We can still use compatible for the same purpose as name.
> >> > Unless it really bothers people, but for me 'compatible' works just
> >> > the same.
> >>
> >> Yes it is necessary, For example if we have two handler for a single
> >> subsystem. We should refer it by handle this or handler that, not like
> >> handler with compatible string this and handler with compatible string
> >> that.
> >
> > I still feel like compatability makes more sense to me. Take an example:
> >
> > We have two file handlers for memfd (i.e., FH_OLD and FH_NEW): one has
> > compatibility = "memfd", and the other has compatibility =
> > "memfd_next_generation". The user chooses one of them to preserve the
> > memfd data, and the compatibility string is saved alongside the FD.
> > When the next kernel scans through the registered file handlers, it
> > must find exactly one that is compatible with the preserved data.
> 
> I will open this for vote.

I'd rather won't ;-)

"compatible" does not contradict more fine grained bitfields, and still has meaning.
Just like in FDT world from where we inherited it, it means "these ops are
somewhat compatible with that serialized format, will check the details and
will know for sure".

And IMO we should keep it.
 
And please, trim your responses. I had to scroll 463 lines to see there's
nothing there.

-- 
Sincerely yours,
Mike.

