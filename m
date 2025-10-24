Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 221CFCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F1B08E00C3; Fri, 24 Oct 2025 11:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1DC8E0042; Fri, 24 Oct 2025 11:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690D08E00C3; Fri, 24 Oct 2025 11:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 553848E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:50:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F389413C499
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:50:58 +0000 (UTC)
X-FDA: 84033446196.13.F840C97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 79440180012
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:50:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eVzGB7lq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761321057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QT09lgkqFvdb4sxc2uHef6Zn0DKdgYGhMs8yyKwAcNs=;
	b=F7iRLwa8+MNHeS/pLdbegXYccVf/4tXTbZJog9sjk6CpnlZUYzr4oTt8rjF3ziMWh9s2Yx
	AHrDIR7tHsX1p+65QV963mDB0q6FFfhlN9Bkmkik/KFWlcao/i6viQNprN2rPUaL8OHQlH
	XNlEnY/5kwvKbin+tB6NOMrjDs0aSuU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761321057; a=rsa-sha256;
	cv=none;
	b=8gMXQ3wD+tf+Dk6kfcV0XxXK03yYnE7K5pJHT+rrR6pHlrsCmoCrh8zf6HMaA+QbzM4ccv
	j8rB5zlvp9n0bJFqqS6+SAoCzQK97vdA5v+Oqh+fnMD99CN9fyw8VEYyqKiQCCKOSqc1Mv
	UBS2boRelERXB+69SwNcrZR4sQFl9AM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eVzGB7lq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 45FBE43212;
	Fri, 24 Oct 2025 15:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2638EC4CEF7;
	Fri, 24 Oct 2025 15:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761321056;
	bh=/PyVVXZMWN4PunxnwU8KXSOp8sSTJb6YyMZNyGFJrqk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=eVzGB7lqmsOpkNO3nJ7BzRCB/x+t6IzqwNR0w6WsW74BW6wbUEGBiCdGRtUvQxiQM
	 Wnf0wusKk4RGiTTeZowjY+T1Q6M6Q7JI0ycTRaFOcKN1wUHfBHiFO5Ftjvd7QUCuKr
	 iiNKX5F1RnhHjCfCPRd62eLKjhyAGuMbrN7E2F57BE5M7qubSvelrgZFODQK1z2sXT
	 Yt3YrZVuK5qu1oPzVPLvFeQe/3PwvCCJgIEz2tgg3+3DxINHjcykc0Ce+XhNFj15dL
	 JfSxTtp3/vfeBf9FfxYVRVZOmeu3TkHrPyhIaf+/MQoTaZ2BV1BvZKI0p00TcloiMu
	 64S4lZX17ZvGQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  akpm@linux-foundation.org,
  brauner@kernel.org,  corbet@lwn.net,  graf@amazon.com,  jgg@ziepe.ca,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  masahiroy@kernel.org,  ojeda@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org
Subject: Re: [PATCHv7 3/7] kho: drop notifiers
In-Reply-To: <CA+CK2bDrrg0UoJXpeN+Au2-sreYrZ+DHVcEUidzPw2Qk60orgg@mail.gmail.com>
	(Pasha Tatashin's message of "Fri, 24 Oct 2025 09:11:16 -0400")
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
	<20251022005719.3670224-4-pasha.tatashin@soleen.com>
	<mafs0ikg7fbez.fsf@kernel.org>
	<CA+CK2bDrrg0UoJXpeN+Au2-sreYrZ+DHVcEUidzPw2Qk60orgg@mail.gmail.com>
Date: Fri, 24 Oct 2025 17:50:53 +0200
Message-ID: <mafs0o6pwe1sy.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 79440180012
X-Rspamd-Server: rspam02
X-Stat-Signature: 51s59nbxupgiysq3xptfzrpa348ixu34
X-HE-Tag: 1761321057-345567
X-HE-Meta: U2FsdGVkX1+HVYURvyFssJV2ySgq1oc+gQdSxo4clo3wUH6z8gZE3XitoHhzxGgcRxNBgW+VOZx3ZPKpzNMyht/na9YGKkpDpXaCKkuoDF2EdFA2Hu3ZnfLaLl/y0oYJshS5Wxlc5HIsDX+vMlYSQYwPjnlEbHGCbHrnZdcadLwz/2LiM8iGsmByN3MzxuFaypbZ+ZRHj6nFTRbvtUyHgPe0wvdWdWr7BmpROmmSl1NV53vruweJHSxckPjI927F1ByPEVt0No3EQ2Fp34FvrJ7GYS8Zg85HXWkohwqwWfKB0SCa2g0CyJniQri+1mQGFOIpC4unXQhMyZtLWe+AFHZMsrU1l/6O+hCQmmYsq2gb7kl4/M2P8E5K+7bTS4Dn8mgBPGLCjQSwmD7wBO3CB9SgnzwrNIu3oOOjrb8tUlete16GSIfFE3FoSxRL45pxfaBeARSLUe8SrkORtpi4/urVlkdrQUk9b3vhN+46h/As6Y0Mdo1qPHOSuMnb9EqzM4cFFB6ZRRzVJtYGv/Y2+LxZrWAHaVveiakJSppdaVaLiSyjo5mN2CrrA9Fe+46bOe3gWUrF3b2bAdQiIfjJoWDLZYwT5SOfNf/vdTR0Rx2WY1hBQkCf+9TEMTlOCPeEs32tM5OshSzybJAvFYvytJe50+uyIU/ybnM44T3v1efQxoF3COcdGJErm0ykbO9OOG8WxT17dgqOEbe15oNxFvFxcMCaucRc/mNJPpJ/4tOR34wDH0JNdiGEDXDCJndG7RVhPu8vd8f5J4ToiCL+rHYcb2NyWZkDPwdS62gYSEfkf9237EDimuIDumsXgPQI+l5QNqU7jIgX+u3UwICZ+L8hAyndlW97HIMJlLpNJjhnV/hfdOANr102CdsmQrNZrbNCyAg8LLMnd5o7mQfs2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24 2025, Pasha Tatashin wrote:

>> > -int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
>> > +int kho_add_subtree(const char *name, void *fdt)
>> >  {
>> > -     int err = 0;
>> > -     u64 phys = (u64)virt_to_phys(fdt);
>> > -     void *root = page_to_virt(ser->fdt);
>> > +     struct kho_sub_fdt *sub_fdt;
>> > +     int err;
>> >
>> > -     err |= fdt_begin_node(root, name);
>> > -     err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
>> > -     err |= fdt_end_node(root);
>> > +     sub_fdt = kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
>> > +     if (!sub_fdt)
>> > +             return -ENOMEM;
>> >
>> > -     if (err)
>> > -             return err;
>> > +     INIT_LIST_HEAD(&sub_fdt->l);
>> > +     sub_fdt->name = name;
>> > +     sub_fdt->fdt = fdt;
>> >
>> > -     return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
>> > +     mutex_lock(&kho_out.fdts_lock);
>> > +     list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
>> > +     err = kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
>>
>> I think you should remove sub_fdt from the list and kfree() it on error
>> here. Otherwise we signal an error to the caller and they might free
>> sub_fdt->fdt, which will later result in a use-after-free at
>> __kho_finalize().
>
> I think, it is better to simply do:
> WARN_ON_ONCE(kho_debugfs_fdt_add(...));
> Now debugfs is optional, and there is no reason to return an error to
> a caller if kho_debugfs_fdt_add() fails

Yeah, that works too.

>
>>
>> > +     mutex_unlock(&kho_out.fdts_lock);
>> > +
>> > +     return err;
>> >  }
>> >  EXPORT_SYMBOL_GPL(kho_add_subtree);
>> >
>> > -int register_kho_notifier(struct notifier_block *nb)
>> > +void kho_remove_subtree(void *fdt)
>> >  {
>> > -     return blocking_notifier_chain_register(&kho_out.chain_head, nb);
>> > -}
>> > -EXPORT_SYMBOL_GPL(register_kho_notifier);
>> > +     struct kho_sub_fdt *sub_fdt;
>> > +
>> > +     mutex_lock(&kho_out.fdts_lock);
>> > +     list_for_each_entry(sub_fdt, &kho_out.sub_fdts, l) {
>>
>> list_for_each_entry_safe() here since we delete.
>
> Not needed, we are breaking from the iterator when deleting.

Makes sense. Didn't think of that.

[...]

-- 
Regards,
Pratyush Yadav

