Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079F7606A332
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CRxphTxS
Received: by kanga.kvack.org (Postfix)
	id F01EB6B05BF; Tue, 10 Nov 2026 12:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EABD36B05C0; Tue, 10 Nov 2026 12:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC45E6B05C1; Tue, 10 Nov 2026 12:03:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A97B56B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:03:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AD9E809F2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:03:54 +0000 (UTC)
X-FDA: 85419831588.03.511FD4D
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4086040006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:03:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CRxphTxS;
	spf=pass (imf07.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794330232;
	b=u9AMXacMG24dgvrCQvPZtBoaGIb5wu3rPI63q2+4gN/a6oyZ+WTwS3if8Ye8j5ZQosE00p
	LR/8qsRnAteRhc8ibZ1RvDbHHLCPwWvqfuoiM67XJh3mcKx5pIBt74BbBjq6s+qA225OCy
	b3VYgC1fc+HU3cHrNZrMrx0yw9samTk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CRxphTxS;
	spf=pass (imf07.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794330232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqBeli1UK7UsB0colEXax3/fZJsEEio4CkgX2Fv7UF4=;
	b=Qq/bisfwVQRWWMdDQ31GoABgscMmJMJewZDUsrYXm38mljJtHW2zRO6jTCm33L/jPD6TAg
	0SYP17BNKGv4jR6Ms6U3UT6Wb0AEDfSvAE0a98HTiO8hIo2WKaNYPUjV7KlP9eaNHe2uKr
	sQ2iqj4+37bFYQz3SMITFx3EF1RSCs0=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc751eddf25so1173980a12.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794330231; x=1794935031; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vqBeli1UK7UsB0colEXax3/fZJsEEio4CkgX2Fv7UF4=;
        b=CRxphTxSKht68usCMZOdpMMSvK0IK3OEXh/+KtZSogHPUcbsK2QteWM4vdCUEZRgEF
         f2DhRtHm9AvFQY4UKp+yAGfTKjy3lrevEUSGjcO0xpSGipKz9VcQdpnStH7KNu6OANTN
         4Ol/Mb149JHR4y3keKeqsru6zR4iZU0SlCzVaqr+B2PakDPJRspsFmuSxsZbH2C5Qn5H
         IHa++/r5CpvBkofK1EYM0jsXZaQpBuZK2Cxn/fhj2x288sCeAwS5hfpObW2rrVfOmQAe
         MGibWeNaCHvUdRx/MscfGQ4l4FIsqNkiYTr6sed47TdIqt+KWUxDZaOhxi/1rKvlk2ZW
         tr6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794330231; x=1794935031;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vqBeli1UK7UsB0colEXax3/fZJsEEio4CkgX2Fv7UF4=;
        b=KW+F23WBcL71pLGbk/QW8pJzP0fqgUL3fhCtj1hf4oaFlUkR0LD1lyzp7X0Mv5c+4X
         87KhLscaGT2CHhORBstEVmXqFQTTS3Y0dwtX2Wa4jRQ8qE0DHjRUq2QrJRq7DbCR64b0
         cXzD0wbh0xS7ejcv+Wxmtb3R24ULq8nIrGPWfvdhVEvM79d+GBrqGoiv2fzVXWzW5oZO
         9ofhadGlvuIM5j4uX+0wPMEvka/lNmiHCSIUUKF7MqgnC3xG3fro12BZYgZjeZYMo9nD
         0GSSNC1OWSpZstWbjucHy/uTiJNRpV9sWt3ukxSLVbJp1Y8typdV9JKPwNh9ZZMpHQkq
         zHhQ==
X-Forwarded-Encrypted: i=1; AL+hErGIeb2AB2sMHKyy1+/bNhchA37PbcVyOdIMas0kMrOUee7uQQy+Q2/qVvfcf3DLt7WvQw+TH2vEmA==@kvack.org
X-Gm-Message-State: APuU4Z9WHOnQ6qQgfatD1QW/7fkRicE37mundENB068t2gYHkiezix6N
	iRw5km0Zwe8o76Qw/MtSkMzJkF7nrvKYczl85fm1dqaa92IYkL7wXn5c4BHOTumCBQ==
X-Gm-Gg: AYBFou2WNITvp9cVKYB0WMEXnlqFnl/ZwqBup7xL9Qk1L8Zrpvf954A7/AKZl2iLlme
	QWacckzo9L71NeOqHi09YxVnkLdRI4uMHa+yh/OM9/7fLc8JeVxF9xaAzrEvbnGCSg4Mg6qvpeg
	xyVNS7JZfAI7mKAmeHnLjgYm4FE7kQzTM1kPX2xVMdW6PmIbsyN7lvemxqFnNRNt328NCAv8ac0
	x8eVbdziAMAG4iwPNw9FAJ9ZNTjYtKz+m7KEInRcJHw4yd29tNa//BaoSGdrrFLTXaNxVvFFvAV
	506gVCkXYMrNlkyxmJKpBim+BnKcLA5C1CnCmBTTYunLkhg3leMy9uH94PRsZUZfvFfN0/44gkV
	NSbDjHglZ2qw/S8HMw/CgxpuastUqRM+vzQSxVIv67zSO11YLPtMGCWOqGkdehMuRgiUnT92KzM
	LpvxByqTcTjt4MbFJzZSTRSZZY7IxEwj9lrerm/3fXNQ6uK/Pp1N7uasHv0pVyyh5/ZRIyAkwIX
	R26HXTJSdBYHmeMrl73Au19JBiP3m64d9B2DjQbnuPbfXZqMr451TgHJNgdkPTPF/WlaXFOWTRR
	bNYYCxwrVzZKCnO1W90wvVvJx6opcnmkwEurD0aj5rs8RI1pnmWj4LUAOl0OZIof
X-Received: by 2002:a17:90b:524d:b0:3a6:e901:e79b with SMTP id 98e67ed59e1d1-3b166cc14bamr3213232a91.15.1794330230055;
        Tue, 10 Nov 2026 09:03:50 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm514293a91.14.2026.11.10.09.03.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 09:03:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 17:03:48 +0000
Message-Id: <DMROZB8DPEWD.W2BFC7JIBVZP@google.com>
Cc: <kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Pratyush Yadav"
 <pratyush@kernel.org>, <kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <skhawaja@google.com>, <sagis@google.com>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block
 header
From: "David Matlack" <dmatlack@google.com>
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>,
 <seanjc@google.com>, <jgg@nvidia.com>, <loganodell@google.com>,
 <arnd@arndb.de>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, <oupton@kernel.org>, <alex@shazbot.org>,
 <gle.com@google.com>, <pbonzini@redhat.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <kevin.tian@intel.com>, <joro@8bytes.org>
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-3-tarunsahu@google.com>
In-Reply-To: <20261110050202.529473-3-tarunsahu@google.com>
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4086040006
X-Stat-Signature: uommwgmzsiqn3owof6trx75tppqfc8yj
X-Rspam-User: 
X-HE-Tag: 1794330232-848013
X-HE-Meta: U2FsdGVkX18GTNEWkedLM5/xnwVdUNE8yNt7Bik9d4X6moF3rE9b3R+Si+HRk2OL5PGvaGWqRZ1JJahp1zdatd86+invU/fXcncHrYC+5rXBd+PyCjtSSzX55QBVOQA0k6xVNGqmHURsBOa/0sVArTqJ//Y2qE/kymyb5FuVziCDx0lqJg0/VT/uBq9LcOE0tsNknj9eYHqX+1m745ZW/JBr6b2lyXurSUXTAqadbLjbWzKaX6t4EDojG1NFa/NlIoQ0MAU4PFXZBahM0AG0qSAz8QkajyhM4oW/lWqhP3l2DnC+ESgYFCPiAsa6cklYmjrncmWA6IPhMft4GUzaLXbcPjZN5udRoUzVu2VavjL4TLqCMMlBw7XM+0pgyljX2MHyFKLxa/4tLv+HZVQ41hcvTcMbHr3e1FZgsQPgU9LpSENltjuhw6OssT53EAxCCS6GjKf4cOBh7t17ThlsxXwTLB73YsmopeSJs95xFl1jJsZzK4J3EPl4ibU7phrb5oqHQP2eRx4KR+b0UtDMx1dEyktL4UnQL4rvl0Cxt7uwiOLQYVcpCWpK90IP7EVtwLQyWYVLgQMOwGZR4CAl3A6gVRnj05+e8Helena2MCEOxchRC0Ut978/eOXdUI5naBwKTRL5z6Yzt5ziThawGMKxup9DQ6d05rgXF+76pN6S5ri7CzC1gsPR/WXK4hSE3SyFEa1aM9VOVR8+88wXnU7rsU+K9Lo9N6PjLiywaE64Cxtll/BGirU8G9WTIO9H09dBc9vn7cIC9b3P7KLV7ePIKvkyafrUawR9wFvHsGDkc1qVa2RPfL9RwanqcHFQCU2NK58HWEGd0qdra+Kz0/ClYoO2oXmbpUf/1NI4YNTb/j2R3Zqibw38pppSXYpOn9MkSfxdOCNRvLxzMWEgmZ008dgeYfqQxUjcjISlI29e1tLVZofxmdEX4zlz3aSoBWsYNRsl3sGl+gVpR7E
 HilEckAR
 3YxU6DjTFGJGiaomQtxei9iA3jSXzHf0AhYe3MTaYUN1suJeaM+fWUagzuX4H9od6gQjDxac3iHaO1odl2B94T3qvLLjAVKki9PKK9FIaW3lbagO+CpGQdRpyK0y6USwwxsS4pwh1rgxZnJ8mi7ycYo2eMBD5tPtJCQJ6tmbWp3NJc/6LNWpMoXCY258zQ/b4xPq2MutelPYOMdIbXhnoa073bHJhgx/nkXub15hub4iMNW7s3jCHVp5oWT/ccqranz8xxTF5Fz60mrYDvtu6taNfNQjOcLVUpj6B9WG1ZHfKE/g4HJ7UmAOxi6/8zreus7JSYjJMeUL9X/o3S1CwsltbfAdv7VbxaDakSmyph8iyQeqd+2OMrANGyTlQhV5UoSmN5LlGCT5Rvm5+3185/j5dyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
> Add an entry_size field to struct kho_block_header_ser. On the outgoing
> side, record bs->entry_size into every block header during allocation.
> During restoration, derive the entry stride directly from the block
> header instead of relying on caller-supplied dimensions. The
> kho_block_set_init() interface remains unchanged. A zero entry size,

Since the entry size now comes from the block headers, incoming block
sets should not take an entry size at all. I pointed this out on the
PCI patch (16/19) as well. As is, every incoming path still calls
kho_block_set_init() with this kernel's (outgoing) entry size, which
kho_block_set_restore() then silently overwrites. That makes the
callers (e.g. pci_flb_retrieve() and the LUO session/file restore
paths) read as if they iterate incoming entries with the outgoing entry
size. kho_block_set_restore() should initialize the block set itself
from the incoming block headers, and the incoming paths should drop the
kho_block_set_init() call.

Please also add an accessor for the entry size, e.g.
kho_block_set_entry_size(). Users of the block set need it to check that
incoming entries are large enough for the fields they read, and that
the fields of a feature are within the entry.

[...]

> + * Each block header also records the size of its entries. A newer kerne=
l may
> + * append fields to an entry, so the kernel that writes a block and the =
kernel
> + * that reads it can use different entry sizes. The reader steps through=
 the
> + * entries with the recorded size, so every entry is found, and it does =
not read
> + * beyond the recorded size of an entry.

KHO blocks can't guarantee the last part. The iterator returns a void *
that the caller casts to its own struct, so it is up to the caller to
not read fields beyond the entry size. Please document that callers must
check the entry size before accessing fields that may not be present.


