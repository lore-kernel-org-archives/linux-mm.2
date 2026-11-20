Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C66606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 15:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mVI7RTsG
Received: by kanga.kvack.org (Postfix)
	id C8ADD6B05B0; Fri, 20 Nov 2026 10:17:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C676B05B2; Fri, 20 Nov 2026 10:17:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04436B05B3; Fri, 20 Nov 2026 10:17:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79F786B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:17:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6D6C140F21
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:17:36 +0000 (UTC)
X-FDA: 85455851712.21.5AEAF51
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id DC9B81C0010
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:17:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mVI7RTsG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of praan@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795187855;
	b=SLKfNJO+q6v8kJmo0cjHfvYNeyTX8U+X2s9vDufAPisdi0Yk+98LMK3iQPat4MGDmo2XMq
	Fnoac8PG/DW0dIR2oVQwjsU+2FiLOfCSgwj7uo4IRyGXTQ/RLOtG/XR634rfQFUmMK4mM/
	YhnGPxpOZ9TLBXoQaOLJPk995HQzKxo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795187855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAjYne+BgcE8DA63sQsMZ990H8S9yK78zgr2NZdv76Y=;
	b=vIbY+fJa9dzcvWEgzWqIlc5S90jwGDoJYqT3wpt+hy07QcUgRuFqdZ/rkXlM5p9KvOY1nr
	VN/iv9Ejl10o1+6yLadUr/ulpsROTzGhoKt6jkM91BbkkdjTCXPC4t7fDg5qBTJ/yxJUvI
	xb5FTExFHCcSrsQ/Ddy/ggbb3hB+G1c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mVI7RTsG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of praan@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=praan@google.com
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-150ef97e790so7379c88.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795187854; x=1795792654; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qAjYne+BgcE8DA63sQsMZ990H8S9yK78zgr2NZdv76Y=;
        b=mVI7RTsGmiaeVEwMGC86F/KyoYyjHYBu1q5TNymCN0lWY3CTBL7xxWN5/3/kDm6Su2
         CJVke2h2Sdk/dK55TH70xmE3B0PK+Pxb33T8rw21khUFZ1L9nhpBqmqBfFirh+u/9fMr
         bcbqmyFGnyfGUXgOrN7YDUJpkWA0oFZBbfoLeHwCKqW1Qof577wkqNpcPBu3Z4lbtJOC
         Sng1STTPZ0CUGqyrikaXbU+BP9xoP++6ll8eEEWf06MRgIIqvadPODZb+NaHTnxINZRn
         /MW/InE4aEecshvSovKcvXoSNf0RL8OAdZHIsNYXkoQN1bgDILvle1mKBGUGVLliNSRM
         aleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795187854; x=1795792654;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qAjYne+BgcE8DA63sQsMZ990H8S9yK78zgr2NZdv76Y=;
        b=x0W4dpHzatZkG4Ln7xDWcJncPwrVhJ8gKUIhZDCjTMuQOz599IrCKR+Zfuv3YObSYy
         kjYE0IKDXL8NXJX6q2W83cL2y+STy6IPBhHRGUrQ1NwIw0/4XuQSIIXTdQigZmPS5Iok
         wJFxPZdgOHi8R3BurTe/JYg8u6iiKiq1Jn9M512JH/yyk/e0BUXSvp3/kG+00Jj1ShMk
         JkFwFGbGSggaN/SuPMKWFEyfUv1LsCOh2WZrFjja518AbpYlQ97rHAkFGCwmPXqeB4b6
         7kogOWPFOS4Gys6MoSUCx8iw9ckA7gQ0m0KKyroFtUKCuN1DO2A21VkZZ4GZ3penu4V2
         NsNw==
X-Forwarded-Encrypted: i=1; AL+hErEtElkUXO+sWnr7JvWvWj/J9uiQTOrZs+jmssyeuHWQgFGVDD6khsQ9H4FTbtjBVBjW5601w++ubg==@kvack.org
X-Gm-Message-State: APuU4Z/rjTadLs46dRL7lS1iYtVqD14sHjLBEbdTorTe+PRhAqHcyuwJ
	82l15J9cEd8nSgFMQ8e+jvz+M3beNfm0aoJoKAQytmoqnBIkUBXMPrEIpf5xEkjk4A==
X-Gm-Gg: AYBFou0K4vM4w2R2cQQWlj4s7rggXkv8UDYx6v1mDnRK1gnKYOpxa6PgzHo0xxJYpmo
	pORgGEIBbVACw4bvWGHYNgzDYT/YLl2UhBQI/I64weJAINrKMdTN0fRdytqz39CTRB79qPeqjRr
	qy28QqFbHi+UoyLFB++ykcvQ6lzGt9XbOY2aCLpyCt9oJIuZROEw2R2anxUpEGvE03j48cNKyEy
	p6pxZXh4fugKu0sONHt62Jm9TlYpCByxTS9iXG3UCQqQxsTKsa/Jd5oiz4vblcgRFj3zvDpevoF
	wkAtI3XvMYmnK/IMyzUCzo3r2mCR0veJzipLrtLqGhOkxpKT9+ef2imgzI/1VPNVUfH2dVTTfFL
	k+mQgXr4FFscoQsiKmexQfJ8jxsKn93iLqdPz9uaa0ZhmywkM465maFvdaVQ5BTs4rlnb/yt9fz
	JzUAmDRnsNpix7AZpOF/MJ6nVj4NiZKqdUfy/NL/Qcsz+/mOmLrUTYoyJn7WzQyIPZQ0j7yRTsl
	fgP4OpeSqiecWyCHF32MnPjObR1vTJIBxzvZveaNYnIfXnIb8IYvzlt8y+TFffXEq+5Kcv+FB8X
	NvM5H4Sl9p/33sHGhHJzYDYMOkZ0kh13S7iTGxVgbjy1ktW+tKsTslM6AXf/XHfzmIjz6+5mAMN
	tP7xGC1Q7g2vy
X-Received: by 2002:a05:701b:4516:20b0:1b3:c4ba:8e0b with SMTP id a92af1059eb24-1b557b69270mr1215594c88.2.1795187852837;
        Fri, 20 Nov 2026 07:17:32 -0800 (PST)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567e2bd1sm7441365c88.3.2026.11.20.07.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:17:32 -0800 (PST)
Date: Fri, 20 Nov 2026 15:17:23 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v11 09/13] PCI: liveupdate: Adopt ACS controls in
 incoming preserved devices
Message-ID: <awBkg0ODE436CZy0@google.com>
References: <20261118223704.3286085-1-dmatlack@google.com>
 <20261118223704.3286085-10-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118223704.3286085-10-dmatlack@google.com>
X-Rspamd-Queue-Id: DC9B81C0010
X-Stat-Signature: 1ue61ap6kt1myeacrwc6s8116c8ks7ny
X-Rspam-User:
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795187854-639338
X-HE-Meta: U2FsdGVkX1+5E1FCZiAv4aaOI3IZ3+x3mqgsalL8cQELiSGZCHjkcNKtoLf0zOfJl8AbooCWeTWkiMMlnv+sVT/o9C/jLF75LAs77WSUz+SQsj9PKM+M8k7jKrIFVtlwQGPY6B5lKdeMq0rzs78lo3w7Dn11DL4n8fkH7NzIGzsYwcp040zcE5WsVSJNH/JLMTBXc31LRpaNS+TQr9BZ4Dv1XibviwA06Vjq6l8zYBMbIAT/GIWdSYf8B/CDMTl108Umg5UWEtZRlAT/xVC1LBTniuAaiLbmfK/ms6SiLKxM/sPK7WOIy5/VeJQXQD4WpW+4xLbHscSPvOZYAMAq3iAyguNEsY/OPsqUDYpz4EA6Z16W7/x1hGyGE0bP3Ye8pfAGdns6oBrv38k/DI6BdJis5sAhozEPOHpQqElTQqoFc68xaLVymbgBAAeDQnNwKGfQUnXjCtxhde7wIas1cqPLyiWYICqxtEXYlub01Q+zEUEj9FVLubGqzFiHfNnWO98iRkynB6MlNptbQ/bI1A5jKie7OlBJK/Ck0UK5qaUUYQ0hhCZk8v0O1qFfKTUT7FVqEb13cg5qGPpUc8/FTHAken28UYBtx0BssAXIKpDSAMN7R6EQzuZ+vuo3bjz0+ZHCGMwdDZZUXn3qkaNFKF94Q46Pc+/ZrOLfWnV8/+XBPQVNTO0ySTFeF32kEx0ndPeeHT2vPkGl0o0hB7HQ6+mnScLbkfbiYBc039JmcoktJM/nRjU7epOH5oVQ3CcPUTBaSbA4p0rTrrFsK5nWHr/3P1PU/CH0cbhxEXXXGV9r7NaogQnfBTAhuCeAJ9wvOzXf+om+rA6RQuM8vex94IBgHMqktFqhr2uMpmjDeQSp8pobdOWdvcNmeJjiyLeiX4nf3nTFOrzozVDMyXl5Jd5Iln3F90OKvotLcMjTQvhuwYIOe4kKEUiqFRcKg0Abc7DX7REC6fc+m4Yd6FD
 T0RFH6tK
 ti/BFIiGJn0vdOQoKgGNPrV65BYIc8+N1ZEF8kKBeKZUku66/q7G+AFTY6JifhujE19K5iprtR90MZEPnL4YYf5IJFrSB8gxJQyrIrSUtkTqGvc/NlqSQmy+aX8mswMMtTkNPuqhVdJT/KJwaKtQeiI6W51KM/La3xRbTJfswDBdIPl2jSUer50FeymTtEdGUICW2AoD3To9GeG83sPKzptQ8cBHfWmZP+xPhfiC9uRMQIGyxgBeMnQtpp/6mZ87nDgABbmmKFKP2eKxAPROb4iDVIWY5JNk8DmiMo6ruppHmW7rg1z8iiHKpo/Ze6Be11eE5OH1gLEccyMlJRvSafRpq3yGjeZOckMk1laPaXDlEDUOZCtY4d2O3C1rmBTXCfr5IzRhSGyebcdBHYyn4Q1rnAx8bH6KNrKFs9EA7uUADcFiO0zzZQpenzt3fTznfc7te5WNVDsz5Ml842AY2jdP+rYEC1wbRpiQAs+td6/SArbcFmHLtoarSxBI9GfDOkjD1aUoIt6aamBUszJYGVa8nMkpDHKA3zp9TLHJmyyukZdZZhQxyRDCUUa8ZJ7XLcYK29oNT+ZU2+TqRajOG/gFIwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 10:37:00PM +0000, David Matlack wrote:
> Adopt Access Control Services (ACS) controls on all incoming preserved
> devices (endpoints and upstream bridges) during a Live Update.
> 
> Adopting ACS controls avoids changing routing rules while memory
> transactions are in flight from preserved devices. It also keeps IOMMU
> groups from changing during or after Live Update.
> 
> The adopted controls are recorded by the pci_save_state() call in
> pci_bus_add_device(), which runs before drivers bind, so they are
> reapplied by pci_restore_state() if the device is reset. Allocate the
> ACS save buffer for incoming preserved devices even if they match a
> device-specific ACS quirk, since their adopted controls live in the ACS
> capability, and panic if it could not be allocated.
> 
> To simplify ACS adoption, reject preserving any devices that require
> quirks to enable ACS as those quirks would also have to take Live Update
> into account. If such a quirk matches an incoming preserved device
> anyway, e.g. because it was added in the new kernel, log a warning and
> adopt the device's ACS controls regardless, rather than reprogram a
> device in the path of a preserved device's memory transactions.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c | 75 ++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/liveupdate.h | 16 +++++++++
>  drivers/pci/pci.c        | 13 +++++--
>  3 files changed, 102 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 00d6fa5236e9..b99a88c2c199 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -123,6 +123,9 @@
>   *
>   *  * The device cannot be a Virtual Function (VF).
>   *
> + *  * The device cannot require device-specific quirks to enable Access
> + *    Control Services (ACS).
> + * 

[...]

> +#include "liveupdate.h"
>  #include "pci.h"
>  
>  DEFINE_MUTEX(pci_slot_mutex);
> @@ -1071,9 +1073,13 @@ static void pci_allocate_acs_save_buffer(struct pci_dev *dev)
>  	/*
>  	 * Devices that rely on device-specific quirks to enable an ACS
>  	 * equivalent keep that configuration outside of the ACS Control
> -	 * register, so they are configured from scratch on restore.
> +	 * register, so they are configured from scratch on restore. The
> +	 * exception is devices preserved across a Live Update, which always
> +	 * adopt the ACS controls established by the previous kernel and need
> +	 * the buffer to keep them across resets.
>  	 */
> -	if (pci_need_dev_specific_enable_acs(dev))
> +	if (pci_need_dev_specific_enable_acs(dev) &&
> +	    !pci_liveupdate_was_incoming(dev))
>  		return;
>  

The ACS save buffer is forced for incoming devices that match an
enable_acs quirk, but neither existing quirk keeps its controls where
the generic code saves them (Intel PCH Root Ports have no ACS cap, 
SPT/UPT has the Control register at +8, not +6). Is the intent that 
such devices just lose their adopted controls if they ever lose config
state later? (e.g. a Root Port D3 cycle after pci_liveupdate_finish())
If so, maybe worth calling it out in a comment?

Apart from that:

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

