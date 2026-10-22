Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC6D606A327
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gCaXCxSB
Received: by kanga.kvack.org (Postfix)
	id 0C5F76B0835; Wed, 21 Oct 2026 22:04:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070566B0836; Wed, 21 Oct 2026 22:04:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC8276B0837; Wed, 21 Oct 2026 22:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C12FB6B0835
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:04:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40F77A02DF
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:04:05 +0000 (UTC)
X-FDA: 85348616850.03.D1D5FC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A1D85100007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:04:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gCaXCxSB;
	spf=pass (imf05.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634643;
	b=Y3a3+7vGq89jB1zZPW69m1JtaUIGIvDIj/6AK5IBETACzlaBpXh6VnujYFgoPVhTT/QDP0
	YrRZ2acxV05C3v9F7OHFQ28P5I5M1xaWl8hnxc7XZaq1LCExmi5FYxOW9+cqNGwWbrTODX
	RsjBL3G1scqcxbLU5HDwE06DAQuU8z8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gCaXCxSB;
	spf=pass (imf05.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dZrxIbh6RTSU4Bjb81Y9TDCjOr0VKfEVlrnhiqKUd4=;
	b=Ty6NeW4r22OheDx3jexbaWPk85yUldKTppwkSnwKnwB6BgrH+mii2rwyGx9qcVY36xGKjO
	ZdNaXTdogAveUmKHWCFNY8axIPAfHlAsUWQmKO1yf3JZ/PyY0gpHPl4FxpWldFFjHfRp8+
	6YVXRJZ0PIJcaB6eVWDFsqvlyovNq6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 611C460213;
	Thu, 22 Oct 2026 02:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4C71F000C1;
	Thu, 22 Oct 2026 02:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792634642;
	bh=/dZrxIbh6RTSU4Bjb81Y9TDCjOr0VKfEVlrnhiqKUd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCaXCxSB7dbVifOnVq9LNkGNcuToeD9pkMlyYHvcSgBqYZbbEYyKtPP5yaMMxYhpe
	 xnliqHiuTvP+za3qjEP/ysbvHJeoOGQpAxOesj0123Mk1ZDbYOYl/OchrYABVKLWDS
	 69oNhNzjdwp+1ZMwnjF3+gu16C+hyq8+Z3E60IYreHV7ZzhGRvC84hPvpsNY/j9Kdc
	 dcQTSYqcGh/rko6aBRV4CxhLyWmSMd/Fg0W3Ny9j8H2TBafmDLsUGdeNb8044rIo5l
	 OlO5Z9nRQtAl6/2/CXu9aWD/sF+KYg0EW7jFOHYOlELgdovho45NLzQaTSGecNzWiO
	 wkZwUQEYOPT9Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Laight <david.laight.linux@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Luiz Capitulino <luizcap@redhat.com>,
	Matt Fleming <matt@readmodwrite.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	andrew.cooper3@citrix.com,
	gregkh@linuxfoundation.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH 6.18.y] KVM: SVM: Stop toggling virtual VMSAVE/VMLOAD on intercept recalc
Date: Wed, 21 Oct 2026 22:03:29 -0400
Message-ID: <2026-10-21-1-daily-reply-0004-kvm-svm-vmsave-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019214611.404880-1-yosry@kernel.org>
References: <20261019214611.404880-1-yosry@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A1D85100007
X-Stat-Signature: q8m778kegxhz88r19dqhza97bkuesd8t
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792634643-777232
X-HE-Meta: U2FsdGVkX19aD0s5F82/JhW54VEXhxNLVEVCpBwQFLezh+OQNsrX8f980HpcCdc2RUr2wzCkGtJfH9p4D/XXir5OUjWM8m7xzoSwEsrvPTf2+i55CbryObvIGpTMSfic6g/CDX63U+qSy3QC5xG5fQ26YgJYGBcq+/Y3GgWD5SRmr2cN3PMJDuwQvLqCZ6Br0f+7pMdZSihn7MuGZn3/tiwMuH9LmV5r0u+XyFXcNRJxz4TJBEjUaVvQeQXY9UjkNNOrXXIJfZEpYvOKlShYv3qjo7aigOOAmP6ihCzlr7ppEqiPDLHGIw9qC8lg7fxW0ZqGsJW60IDTfPtx3JaGiaEnKLQX4XIwLGWTvXs7teFQFXpMbnM+EFhK2x1xFxghTM2yXIwAMgKQ2UmHMYEIiQfsKCguHc6PX+1XZavRqzofKRC/U6qyE/w+vORUhcYI/zf+d54tzUQiZu11awA5s68gAqzYyZpUAqWiZhTcwIt4umj+WDR7lXU+uOb/UZRjjd/cYoiz+dJ13DEuVVSZOiGFkbb/mGgzVxrks2FVKgqh2qN01rfUDlesHQmZ6Q/nHqTl3RJZL7RHk8jwsz1B6p+LqjUct+FuPUx3fd9M3y0eFXz19Klvw1QgnVx+UiDS8hPDc7DdSeYm586M11nUD0pHP+O/ZWO4pG3Pq96nBTomvLPcosLdD3mpwDbXShkxY/CgeWjrrIIZQq2wjFO4yGrqx4vfnvxRf87jrLOSlOPjbhovE311FSgXi/MTfpM/WSK/zGJdpowJOOFkUnYRSN0jlhFDJJULQUdcYbtwLTNV2a8nFdts7ZZMi+551kOrdv0ipEyhiNo6zngRyshr13NBx402LYrFrVad1+Bi/3iA6vyzjChMe2WwdcTgRl2XyxhXoPVz4s8ePSDkqc3eKtXl0Ipf2D/QIJITth4Jpp2srhREmYYIJvgNlJpkzSj+ewiDocfztsajVnBrno4
 7fY4nS4j
 V12F83EKsabCYPZxOAbzHDgQIC3B9Y2ZGp/+8xjjptWjsJkhHD0w3MMqcxfLl48LdWGC33ayoQWtBTyyBxUSvIeK7m5KcZ2J7JGabmKNflLlQNxGv/CNdg3s4LgiOjMBWGyAKircf9zXOYCqY92v1HJ6uSUt6Bl0bW5SvSPiG5QCVs+YBsMzuocGZRqAMWcbpjZLlpUBkHKrXF0YC/Gr5pJDhbnCjHZSlMnA+k4B9qaM7Zs/8z/Mk00+RaOPOsT3a2V1/DPRH67otKSDAUh/asK/yn7ZQ8jzgunvv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Virtual VMSAVE/VMLOAD enablement (i.e.
> VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK) is set/cleared by
> svm_recalc_instruction_intercepts() when the intercepts are cleared/set.

Queued for 6.18, thanks.

-- 
Thanks,
Sasha

