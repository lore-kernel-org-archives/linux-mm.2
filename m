Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE4ADCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 13:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169266B03AD; Mon,  1 Jun 2026 09:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140FF6B03AF; Mon,  1 Jun 2026 09:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056A36B03B0; Mon,  1 Jun 2026 09:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E830E6B03AD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:50:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B59511C07A3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:50:54 +0000 (UTC)
X-FDA: 84831479628.06.3FFF7C4
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id B573812000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:50:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BsV5ieNM;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780321852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BfP3m3uDINOt0fM7mrJg3TEw4eDdUgfRDLxACEeD8dU=;
	b=mF7/GFvLx3SJ0lh7IaXWVK8XVsACoyrcdMHhuLAHDgbUVdrkr3Z1AbK9cOZSy+rvbpjZ09
	ftBzVYwd3vRCUMJ6CK9Iyg6HfRZuNDSgjlBDb8NRNJmCKQm/FH6Gr3Tc6ACDoiQD6wvhTI
	eNwrRCmM1yw4KJ3sovMQBwb5ujj/03Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BsV5ieNM;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780321852; a=rsa-sha256;
	cv=none;
	b=yJL6sXVM+Agkqzs6sZRegCaZ7BHoxnA63k9RdI12V8qotRJhfddPKDTzrCigoljPcfZ+vA
	HRUseRb6myOS8vnOrLhYyjNGzzMZfKx+QmlAZ/6dESRNgOaokr2KGs1IjigGjHtnEQryKc
	RMeIB/nWvoy4NWThM6AUACx8zKYwF2c=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7e2cb01a974so15779767b3.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 06:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780321852; x=1780926652; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BfP3m3uDINOt0fM7mrJg3TEw4eDdUgfRDLxACEeD8dU=;
        b=BsV5ieNMabi5QkB8CA1nT61gRg/lm0VD5z7f4t8UtMfM03lC8s8Lv3KJmMxAfNwZ/m
         NHT4soTseC+qnVv1qmbMOwQ4VPLQ95J8I8cul23z4fIa95zMeg/DN+xRvqpcwLYjYsDz
         t4AO+8lGHVhxaOxCm1Yz6zokiGbxv/dgvNw3FyFci6vdwjO9e3n03n91qualy4iSzmvw
         lUA6ndZwFd1KXb6bTDtztdjEP7AKILUAu00b8lSTUICD6y9YcrKmvc+XdjEnSU1aSlPT
         IJbSa64LWHTvnIOkUZ3DhPmQmJloCQ+rr/0F1xDw8QHTqWS+Gw0+TwvopTCZZgmRNVlS
         TgEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780321852; x=1780926652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BfP3m3uDINOt0fM7mrJg3TEw4eDdUgfRDLxACEeD8dU=;
        b=eK3jn3l4UbBC5c4JJ8AbMyXjM7BHTMYCfAf7sNNRkcVgcmKp+5OI1puY5Ce9VNVtTB
         3x024IaWHjvcbzgazuzubjL3AHj/5BT30YmbNVFUDbJ2ZHt3wWyyy3fwiyagXvSmkFri
         Al4QLOEzX8kW3B0dE6iKxyeAk9jYx36ciooC622IoTn0BrlMzBN/HXfBFjbfAHKGhZO4
         drjP8hNU4jUito8TTAMqVdeOd3HEFpFSZ7zc4UTp8ztW4/dtTYxWMKg0z0Yufsg2YsMm
         nIevc0Uz66WdbbVM1js8FhsRzk3hC3uWh08Ng6ir5Y6MyYSowBEd7cwrzyCOX7JxRkV/
         ZL3A==
X-Forwarded-Encrypted: i=1; AFNElJ+KSHMFFGS04hHf7TxiEXr+lO7V5TsqIwjnwjsjFXNUB3jb/HiACdMLVnp7nh6xnKD0FLiDlum5Ug==@kvack.org
X-Gm-Message-State: AOJu0YxvO4V1+NzCPZoRrGN7ih6yE2K/Jw07my2y61SuOsMF+CqD1ZeC
	aWLIuf92ykTxsxO6rCRcL8G4N3gCkiYOxyyjnLLNllMUstiYPeMsFmcoSpBv9BZlA6E=
X-Gm-Gg: Acq92OEYtz/foPUNBNHS2ZDmEHQclefoNdy+7hqhzMuiaX1ufLPm8MWO9Xwcn0IAfOI
	TLnyDmRou9fuAewH+VN++iIetXFHoMijGw72pmUJhGQdLN/BiT+L6JF/W98otf3aDxDcxNVty5C
	0KVUYxRjGZrOwHkPuGcjEfcuDLyn/XAHq5bPpn3CmsomYIkMcimfKFlMZtkzU9+PGoFzvnrXOX9
	sZqVITOrFuErG3X9cQM52DzP4QU/BBpJRUq6cJ6VfTtdLagIRUCQ06LzRibLAsLWvJGCBdB9Gx4
	wSV7O/DQsgQu1yZFRcaZgjkHLD10H5t/rPX6F23vZpPHdtUGBzn6tA2vLvaRuwTwWS//fEuB+3w
	up/wC5zj2kcInk1wfCq3cljV0dtHUuC4MmlHy7JUf7y/iNh4+JdPNGlVShgaDGpvEDx66W41IpP
	JhsHnnvFDBNXPKyAq8xQUifeVfzfH4348ZQpdgAGE395SNwAd3vRhoHKlHXOc4Enosigb5XdnjM
	M5jhkdIvkqrX1NW/XOThb5byWEAg468V7DUC81pG4E=
X-Received: by 2002:a05:690c:6311:b0:7b9:39f:62c8 with SMTP id 00721157ae682-7e05d8ceaeemr99332547b3.27.1780321851614;
        Mon, 01 Jun 2026 06:50:51 -0700 (PDT)
Received: from google.com (138.200.150.34.bc.googleusercontent.com. [34.150.200.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7e17be07a17sm39858607b3.34.2026.06.01.06.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 06:50:50 -0700 (PDT)
Date: Mon, 1 Jun 2026 09:50:49 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v4 04/13] liveupdate: register luo_ser as KHO subtree
Message-ID: <ah2IuC1Z1ssIquXZ@google.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-5-pasha.tatashin@soleen.com>
 <2vxzv7c2fn8n.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzv7c2fn8n.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B573812000B
X-Stat-Signature: yi3hy1mtxty3qqup5zhfo6hmr31qaz9s
X-HE-Tag: 1780321852-43654
X-HE-Meta: U2FsdGVkX19atTjh/K7HOXDShS/7g4jtwT0h9R/iPQS1QgHJ802gg22NIG2YXmfucw6sv8NKppNdxzuca6Upkkuoi9vsN2NBHgKwJSjF1gsL0t2p/PcflK1cDFHM5LCJmH2gHSWBG0005CNQq6kp9+rENykD+/P8QtPKTRLR3z0WOXhrA3KemiZUA1igqRejq+vsp6me8+ubCQtlZWzUr3/WUJb9OAm4zK3B/ZBidVvYPyuDXziXLPGRvOhjOsOQhvvaL0UWMBIR3clCRdCR1v6fR7zILST+HsfNkkEkv1ZwIiaj4HVoDY/fHyjwM3L4tslisDxmC6U3gxVELOwhIzlI6AW0/3kcRO1HS5gUY8N9TLbMrpS/cMBIcISjwMR01h4nKnouQHJ0inNzsosInBkTRQjmd+erMKLdTEGWvynqN8eOCI5DgAPxJOUpXe9sO8OW8UT/bkU2c4QlxZUNskhJNO0UsrmMwZo3WbnWpOYQbxy2D+9P7UjBu8e78OL1x5miuC8CdOESWURwCT6TgZ5UCcPl92EIRN8uht+buki6IclCg+3EkHTIeTyVXxNGo+OSCWuKwZG3uYiAF4vsZzm58gDdbHCmiN0rZtX2w3V3srD36vuyLxrrptIsG3h9+VY+AA3vaJRBV3k+cMc9/Wh2HH00vEVnMGfduwquH3Fyl2RhXPu8hP2ZFvEjKkK2I9Qjas9JIZao1M+95RLK2TPhcVXl6uqXtN2le2M4lTUAEfwDj83D+CsZWwNNiqSxtmcO2m2S54OEMkudoDZT4UPD4+PTj0py9jRtwyUiI/6fxmHVkOLm99wZgzoCbT1WqfWd06Yr7oUzYPNZnQ594Tj/kj20AcPirtP96Nq3PgTpO9n50qwNlnpXjxuMio96snsk6e4vW3LFL4zV18q0EgwWKEsD6MpmuPzcjL+gMmLuHtajKiP+yK339vtG8Gfq9W8Q6L1ddrD3RKxagw7
 sa/Jh8Tt
 Th75M8nD6P/SSnckJgcdoDA6FncushACuLSDrxi9gfV/IQ3ugTwhwgGlaEUmEkFKVB/he7bLKDDkMou89fDS5spS9zO7rD3921MPpZF3Zh4HiVlSjCjozswClg4IZb6RWQIGXne0W02eHOLIqNkakNKXQR84cRT8HtCM/n9QZiWXNBWlrCClk98bBqsXGuws1ea7bk9rDm0PtfXDE2oYMbDLBaC25r8n4/E2vuIcfgzcGrfPbXmSZq+r2shsQeT2HMYglJwp3s+sYJAGft3L5Q/9gfKs170L/qJWdtgYbbT07SUmsNfW3SRFltikZzAUFRaUZ/KvihxpIThxKPmgMWtPjc6sq0nQU+zMP9uOgkL1NKdyHlLJ4NEYy0vQfmspxGv0BNXrfJaq/zpvtHzKXU2MxBDOTz5/yDasy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-01 14:39, Pratyush Yadav wrote:
> On Sat, May 30 2026, Pasha Tatashin wrote:
> 
> > Entirely remove the LUO FDT wrapper since the FDT only carries the
> > compatible string and the pointer to the centralized struct luo_ser.
> > Instead, register the struct luo_ser via the KHO raw subtree
> > API, placing the compatibility string inside the structure itself.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/kho/abi/luo.h  | 57 +++++++++---------------
> >  kernel/liveupdate/luo_core.c | 85 +++++++++++-------------------------
> >  2 files changed, 46 insertions(+), 96 deletions(-)
> >
> > diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> > index 1b2f865a771a..9a4fe491812b 100644
> > --- a/include/linux/kho/abi/luo.h
> > +++ b/include/linux/kho/abi/luo.h
> > @@ -10,11 +10,11 @@
> >   *
> >   * Live Update Orchestrator uses the stable Application Binary Interface
> >   * defined below to pass state from a pre-update kernel to a post-update
> > - * kernel. The ABI is built upon the Kexec HandOver framework and uses a
> > - * Flattened Device Tree to describe the preserved data.
> > + * kernel. The ABI is built upon the Kexec HandOver framework and registers
> > + * the central `struct luo_ser` via the KHO raw subtree API.
> >   *
> > - * This interface is a contract. Any modification to the FDT structure, node
> > - * properties, compatible strings, or the layout of the `__packed` serialization
> > + * This interface is a contract. Any modification to the structure fields,
> > + * compatible strings, or the layout of the `__packed` serialization
> >   * structures defined here constitutes a breaking change. Such changes require
> >   * incrementing the version number in the relevant `_COMPATIBLE` string to
> >   * prevent a new kernel from misinterpreting data from an old kernel.
> > @@ -23,31 +23,15 @@
> >   * however, backward/forward compatibility is only guaranteed for kernels
> >   * supporting the same ABI version.
> >   *
> > - * FDT Structure Overview:
> > + * KHO Structure Overview:
> >   *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
> > - *   This entry contains an FDT with the following layout:
> > - *
> > - *   .. code-block:: none
> > - *
> > - *     / {
> > - *         compatible = "luo-v2";
> > - *         luo-abi-header = <phys_addr_of_luo_ser>;
> > - *     };
> > - *
> > - * Main LUO Node (/):
> > - *
> > - *   - compatible: "luo-v2"
> > - *     Identifies the overall LUO ABI version.
> > - *   - luo-abi-header: u64
> > - *     The physical address of `struct luo_ser`.
> > + *   This entry contains the `struct luo_ser` structure.
> >   *
> >   * Serialization Structures:
> > - *   The FDT properties point to memory regions containing arrays of simple,
> > - *   `__packed` structures. These structures contain the actual preserved state.
> > - *
> >   *   - struct luo_ser:
> >   *     The central ABI structure that contains the overall state of the LUO.
> > - *     It includes the liveupdate-number and pointers to sessions and FLBs.
> > + *     It includes the compatibility string, the liveupdate-number, and pointers
> > + *     to sessions and FLBs.
> >   *
> >   *   - struct luo_session_header_ser:
> >   *     Header for the session array. Contains the total page count of the
> > @@ -78,26 +62,27 @@
> >  #ifndef _LINUX_KHO_ABI_LUO_H
> >  #define _LINUX_KHO_ABI_LUO_H
> >  
> > +#include <linux/align.h>
> >  #include <uapi/linux/liveupdate.h>
> >  
> >  /*
> > - * The LUO FDT hooks all LUO state for sessions, fds, etc.
> > + * The LUO state is registered under this KHO entry name.
> >   */
> > -#define LUO_FDT_SIZE		PAGE_SIZE
> > -#define LUO_FDT_KHO_ENTRY_NAME	"LUO"
> > -#define LUO_FDT_COMPATIBLE	"luo-v2"
> > -#define LUO_FDT_ABI_HEADER	"luo-abi-header"
> > +#define LUO_KHO_ENTRY_NAME	"LUO"
> > +#define LUO_ABI_COMPATIBLE	"luo-v3"
> > +#define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
> 
> The length of the compatible field will change depending on the length
> of the string. While that is technically fine since a new ABI version is
> allowed to change the layout, it feels odd. I think it would be better
> if we define a static size here, say 64 bytes. This way you can avoid
> all the weirdness that can happen when you move from one version to
> another.

This is what I used initially, but we have cases where one LUO/KHO 
subsystem depends on another. For example, the LUO version must change 
when the block version changes, making the static length too 
restrictive. I would prefer to use proper strncmp() everywhere and allow 
the version string to change dynamically between kernels, while still 
allowing something like this (from [PATCH v4 09/13] liveupdate: Remove 
limit on the number of sessions):

#define LUO_COMPAT_BASE		"luo-v3"
#define LUO_ABI_COMPATIBLE	LUO_COMPAT_BASE "-" 
KHO_BLOCK_ABI_COMPATIBLE

In the future, we may extend this further as we add more dependencies, 
such as your preservable xarray, vmalloc, etc. Everything that depends 
on an external version should include that in its compatibility string.

> 
> >  
> >  /**
> >   * struct luo_ser - Centralized LUO ABI header.
> > + * @compatible:     Compatibility string identifying the LUO ABI version.
> >   * @liveupdate_num: A counter tracking the number of successful live updates.
> >   * @sessions_pa:    Physical address of the first session block header.
> >   * @flbs_pa:        Physical address of the FLB header.
> >   *
> > - * This structure is the root of all preserved LUO state. It is pointed to by
> > - * the "luo-abi-header" property in the LUO FDT.
> > + * This structure is the root of all preserved LUO state.
> >   */
> >  struct luo_ser {
> > +	char compatible[LUO_ABI_COMPAT_LEN];
> >  	u64 liveupdate_num;
> >  	u64 sessions_pa;
> >  	u64 flbs_pa;
> [...]
> > @@ -94,40 +91,29 @@ static int __init luo_early_startup(void)
> >  		return 0;
> >  	}
> >  
> > -	/* Retrieve LUO subtree, and verify its format. */
> > -	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys, NULL);
> > +	/* Retrieve LUO state from KHO. */
> > +	err = kho_retrieve_subtree(LUO_KHO_ENTRY_NAME, &luo_ser_phys, &len);
> >  	if (err) {
> >  		if (err != -ENOENT) {
> > -			pr_err("failed to retrieve FDT '%s' from KHO: %pe\n",
> > -			       LUO_FDT_KHO_ENTRY_NAME, ERR_PTR(err));
> > +			pr_err("failed to retrieve LUO state '%s' from KHO: %pe\n",
> > +			       LUO_KHO_ENTRY_NAME, ERR_PTR(err));
> >  			return err;
> >  		}
> >  
> >  		return 0;
> >  	}
> >  
> > -	luo_global.fdt_in = phys_to_virt(fdt_phys);
> > -	err = fdt_node_check_compatible(luo_global.fdt_in, 0,
> > -					LUO_FDT_COMPATIBLE);
> > -	if (err) {
> > -		pr_err("FDT '%s' is incompatible with '%s' [%d]\n",
> > -		       LUO_FDT_KHO_ENTRY_NAME, LUO_FDT_COMPATIBLE, err);
> > -
> > +	if (len < sizeof(*luo_ser)) {
> 
> len != sizeof(*luo_ser) here?

I can change this, but it is not necessary. It is common practice to 
verify that a "struct" is not smaller when compatibility is checked, 
allowing for future expansion without breaking compatibility with older 
kernels. I know we do not support forward/backward compatibility in any 
way right now, but I do not think it hurts to put the proper safeguards 
in place.

Pasha

> 
> > +		pr_err("LUO state is too small (%zu < %zu)\n", len, sizeof(*luo_ser));
> >  		return -EINVAL;
> >  	}
> >  
> > -	header_size = 0;
> > -	ptr = fdt_getprop(luo_global.fdt_in, 0, LUO_FDT_ABI_HEADER, &header_size);
> > -	if (!ptr || header_size != sizeof(u64)) {
> > -		pr_err("Unable to get ABI header '%s' [%d]\n",
> > -		       LUO_FDT_ABI_HEADER, header_size);
> > -
> > +	luo_ser = phys_to_virt(luo_ser_phys);
> > +	if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COMPAT_LEN)) {
> > +		pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_COMPATIBLE);
> >  		return -EINVAL;
> >  	}
> >  
> > -	luo_ser_pa = get_unaligned((u64 *)ptr);
> > -	luo_ser = phys_to_virt(luo_ser_pa);
> > -
> >  	luo_global.liveupdate_num = luo_ser->liveupdate_num;
> >  	pr_info("Retrieved live update data, liveupdate number: %lld\n",
> >  		luo_global.liveupdate_num);
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

