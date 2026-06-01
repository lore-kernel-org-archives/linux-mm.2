Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB19CCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2652B6B03C9; Mon,  1 Jun 2026 10:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215CA6B03CB; Mon,  1 Jun 2026 10:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C806B03CC; Mon,  1 Jun 2026 10:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 013AC6B03C9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:27:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F36C9140738
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:27:45 +0000 (UTC)
X-FDA: 84831572532.17.A798523
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 616D520002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:27:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkqbiUbo;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780324064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6cYnnzACAa9rfQIMX8lKTai+iu9oUQg0E7LR5+SnJk=;
	b=2XeRDLofWvWhnRFSHlTPPX3Ydri3wxDBWZEIdCqLVk3rhMobzP3ahxFzSdk51GOZO4nMta
	QoeARSETUMslqUmowsHb5xf8bFwSp6A9y6WbcAJ3uBK4C53II699S4v8Q6L6KxMcsIYYDR
	MF3IZqVt12VtCpmk7F5x5D32+X73QrA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkqbiUbo;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780324064; a=rsa-sha256;
	cv=none;
	b=P+lHmVon0Mgtgp7NGFt1EFhhFaj74Ii+IXArXerlNcev3YEf1dj5Vk+TUm7RJZR0P0vzPh
	0gJ/QTcTCiuvMcFlX+Bm9tyYKNGe2Yi/UNp9nQYBVvVXxK8icot13ofH6ci4lMF2Smu8u7
	az/VMr5QP+OXnCsCm+Klqy93Km6p31g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C668E600AA;
	Mon,  1 Jun 2026 14:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A20E1F00893;
	Mon,  1 Jun 2026 14:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780324063;
	bh=E6cYnnzACAa9rfQIMX8lKTai+iu9oUQg0E7LR5+SnJk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=BkqbiUboImcBpFzhhim8gXs3eM4oVcNpPJhx28BaRVW29Uj6I1NrnY+BSpeIKkAbj
	 k/Ln7lWvc3p5huVDktcNnF9DmVoNd3iUwsmJi05eQmopYWcYfbxWZ1pazLsyz9Q72C
	 n0F0+e+zp+JFicqWfavTQ9UPuGHz8ebqrD/QhwTt9K3PZ+zKuW02NSmLOpa86xOiRx
	 vG11abP1sf920dtUiChQ4xYuN8P1v04ZmfUVUQcxOT2qvxp3oE9ipHnPL0hE7OSAyX
	 Bm8BqKZWPykWPJBi1CcmFnh/YODhdXseQow5IE5VRtSM/jdfuG69SndLqiMYeSHaLT
	 7g3xv+G5gquDw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  linux-kselftest@vger.kernel.org,
  rppt@kernel.org,  shuah@kernel.org,  akpm@linux-foundation.org,
  linux-mm@kvack.org,  skhan@linuxfoundation.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  corbet@lwn.net,  dmatlack@google.com,  kexec@lists.infradead.org,
  skhawaja@google.com,  graf@amazon.com
Subject: Re: [PATCH v4 04/13] liveupdate: register luo_ser as KHO subtree
In-Reply-To: <ah2IuC1Z1ssIquXZ@google.com> (Pasha Tatashin's message of "Mon,
	1 Jun 2026 09:50:49 -0400")
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
	<20260530221938.115978-5-pasha.tatashin@soleen.com>
	<2vxzv7c2fn8n.fsf@kernel.org> <ah2IuC1Z1ssIquXZ@google.com>
Date: Mon, 01 Jun 2026 16:27:39 +0200
Message-ID: <2vxzy0gye3ok.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Stat-Signature: gzgfp6c7gdp5wjikd587jp7i3ko4cd8y
X-Rspam-User: 
X-Rspamd-Queue-Id: 616D520002
X-HE-Tag: 1780324064-78742
X-HE-Meta: U2FsdGVkX1/pYEJed1osB+ovTO8S+yzDGSuMLru51PLrbJIIONxYM/uEDfTOSkhG+J4vCdENFPm9lm+VUZJYpheSvPBofDwqIGHZexJjEKr6faBqq1ad31PQQLeYNMzu/9ScBMTpkNWJzfNM6/IsFqCtFVkVXITnMpO2Y7WPbG9KG9+sWB/r+WED3YgFcspp3xkLFAXS9D9RsdGmN+0kXre8fQjBEuXO3d3PavcNhdkE76Amr8PRjiJ38IOdcQz8yuv4uLSLAJf0MhI31WXST6XYgIDGX2iVOhCLgeJ+rlE6r4X8hJYUQoLM8IXUVcI+2sVz6Gf0wm5C/U/QDUswHm5RbW2c6wRNv5WrHxNPmFA95OsexKdfeAsZLigogQsA5J/hXzbhbe3gKDDlIom1WCORwp7VijhkNp9eEEG0aW/vZTk8HJFmMzsUvexaqXMsHnDN9XCogUMWFj5LoilKhUaOs2ZWMSlOWOQ6s4JeEbuf/BZ/mfYWTJCbgoDVwTbn6biorrv/di/+o8JgxLW04I4e6yKvgT7WvKxESy2E4Yuercshq1EMYroAnosIwEUVYHN05YNPihwV4l6BJ5tIbbPK3V1QkE8j5Jhe+Onkm+6bxs7YPOJrvR0R+iTTdImnvhELSMaUJjveolSaoBuKrVb7kpdJq3g6VPDGHOmTz2B1/cqDJTElkL/jFnRH8ghJV059jdFtpGWz1iIqFmgXO9c3pXbSNcmtVaU8rYg3wWMkCw6VAIpLNaVAQvKPy6zDZ4JbNHJ4z/fjd5k5rKHgAh3Twn7lVTIajDZf4c3+N35+YoVCjgJblljhW29BklHBukOFXnsHtZvyHAJ5kN6Zn4xH6YCzZweU7bohfD9Rws8VnxyCpOXmm0wkhyepc6u2yM81Yj2SG1HzeAoFwkaFDvrKA++duv7g6D4gxM2iCWWby+VIfUrOIwZcYHhur4zTG8z1oWrslBJW3PVbTpi
 EnaaulXc
 fuAkk58cVrWWagrzPARuow+ViwsU/XJDMlTdudiVrGbLfBCXhH11zSqVmIpCTCcx6PnxZbBadnzX6/3AE5/aSI+Mg8fvlPbuCyP2qTSWnuXzJ11ev5ChimFZ/efDCctt42KNLfZBVZxsyvbHWvqMal8ze5ll2ECyEc8iivjhf3QeR1CuwD4jWC75CfcOitMOlWuoY4gKca+FPk8gxqy59o5xxBbirUHY+jLoh4G94tSbdwscPVlEoH9HB1mebxY+KnI4yKh6DHdT8UDUKD7ikgvLIEkxpwH5KSFjCGZl3SiUbvRd0V2MvhAV0PBPu4ka9jUGszPSIdi43ylLGOqtQAuf9oIPiN3gvCYe/X70sHmQRVvBxf1gUfs2y+/DHbQJ+hiPhMuyfqqbXSSg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01 2026, Pasha Tatashin wrote:

> On 06-01 14:39, Pratyush Yadav wrote:
>> On Sat, May 30 2026, Pasha Tatashin wrote:
>> 
>> > Entirely remove the LUO FDT wrapper since the FDT only carries the
>> > compatible string and the pointer to the centralized struct luo_ser.
>> > Instead, register the struct luo_ser via the KHO raw subtree
>> > API, placing the compatibility string inside the structure itself.
>> >
>> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> > ---
>> >  include/linux/kho/abi/luo.h  | 57 +++++++++---------------
>> >  kernel/liveupdate/luo_core.c | 85 +++++++++++-------------------------
>> >  2 files changed, 46 insertions(+), 96 deletions(-)
>> >
>> > diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
>> > index 1b2f865a771a..9a4fe491812b 100644
>> > --- a/include/linux/kho/abi/luo.h
>> > +++ b/include/linux/kho/abi/luo.h
>> > @@ -10,11 +10,11 @@
>> >   *
>> >   * Live Update Orchestrator uses the stable Application Binary Interface
>> >   * defined below to pass state from a pre-update kernel to a post-update
>> > - * kernel. The ABI is built upon the Kexec HandOver framework and uses a
>> > - * Flattened Device Tree to describe the preserved data.
>> > + * kernel. The ABI is built upon the Kexec HandOver framework and registers
>> > + * the central `struct luo_ser` via the KHO raw subtree API.
>> >   *
>> > - * This interface is a contract. Any modification to the FDT structure, node
>> > - * properties, compatible strings, or the layout of the `__packed` serialization
>> > + * This interface is a contract. Any modification to the structure fields,
>> > + * compatible strings, or the layout of the `__packed` serialization
>> >   * structures defined here constitutes a breaking change. Such changes require
>> >   * incrementing the version number in the relevant `_COMPATIBLE` string to
>> >   * prevent a new kernel from misinterpreting data from an old kernel.
>> > @@ -23,31 +23,15 @@
>> >   * however, backward/forward compatibility is only guaranteed for kernels
>> >   * supporting the same ABI version.
>> >   *
>> > - * FDT Structure Overview:
>> > + * KHO Structure Overview:
>> >   *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
>> > - *   This entry contains an FDT with the following layout:
>> > - *
>> > - *   .. code-block:: none
>> > - *
>> > - *     / {
>> > - *         compatible = "luo-v2";
>> > - *         luo-abi-header = <phys_addr_of_luo_ser>;
>> > - *     };
>> > - *
>> > - * Main LUO Node (/):
>> > - *
>> > - *   - compatible: "luo-v2"
>> > - *     Identifies the overall LUO ABI version.
>> > - *   - luo-abi-header: u64
>> > - *     The physical address of `struct luo_ser`.
>> > + *   This entry contains the `struct luo_ser` structure.
>> >   *
>> >   * Serialization Structures:
>> > - *   The FDT properties point to memory regions containing arrays of simple,
>> > - *   `__packed` structures. These structures contain the actual preserved state.
>> > - *
>> >   *   - struct luo_ser:
>> >   *     The central ABI structure that contains the overall state of the LUO.
>> > - *     It includes the liveupdate-number and pointers to sessions and FLBs.
>> > + *     It includes the compatibility string, the liveupdate-number, and pointers
>> > + *     to sessions and FLBs.
>> >   *
>> >   *   - struct luo_session_header_ser:
>> >   *     Header for the session array. Contains the total page count of the
>> > @@ -78,26 +62,27 @@
>> >  #ifndef _LINUX_KHO_ABI_LUO_H
>> >  #define _LINUX_KHO_ABI_LUO_H
>> >  
>> > +#include <linux/align.h>
>> >  #include <uapi/linux/liveupdate.h>
>> >  
>> >  /*
>> > - * The LUO FDT hooks all LUO state for sessions, fds, etc.
>> > + * The LUO state is registered under this KHO entry name.
>> >   */
>> > -#define LUO_FDT_SIZE		PAGE_SIZE
>> > -#define LUO_FDT_KHO_ENTRY_NAME	"LUO"
>> > -#define LUO_FDT_COMPATIBLE	"luo-v2"
>> > -#define LUO_FDT_ABI_HEADER	"luo-abi-header"
>> > +#define LUO_KHO_ENTRY_NAME	"LUO"
>> > +#define LUO_ABI_COMPATIBLE	"luo-v3"
>> > +#define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
>> 
>> The length of the compatible field will change depending on the length
>> of the string. While that is technically fine since a new ABI version is
>> allowed to change the layout, it feels odd. I think it would be better
>> if we define a static size here, say 64 bytes. This way you can avoid
>> all the weirdness that can happen when you move from one version to
>> another.
>
> This is what I used initially, but we have cases where one LUO/KHO 
> subsystem depends on another. For example, the LUO version must change 
> when the block version changes, making the static length too 
> restrictive. I would prefer to use proper strncmp() everywhere and allow 
> the version string to change dynamically between kernels, while still 
> allowing something like this (from [PATCH v4 09/13] liveupdate: Remove 
> limit on the number of sessions):
>
> #define LUO_COMPAT_BASE		"luo-v3"
> #define LUO_ABI_COMPATIBLE	LUO_COMPAT_BASE "-" 
> KHO_BLOCK_ABI_COMPATIBLE
>
> In the future, we may extend this further as we add more dependencies, 
> such as your preservable xarray, vmalloc, etc. Everything that depends 
> on an external version should include that in its compatibility string.

Hmm, it feels odd, but I don't have any real counter arguments. So let's
keep this as-is.

>
>> 
>> >  
>> >  /**
>> >   * struct luo_ser - Centralized LUO ABI header.
>> > + * @compatible:     Compatibility string identifying the LUO ABI version.
>> >   * @liveupdate_num: A counter tracking the number of successful live updates.
>> >   * @sessions_pa:    Physical address of the first session block header.
>> >   * @flbs_pa:        Physical address of the FLB header.
>> >   *
>> > - * This structure is the root of all preserved LUO state. It is pointed to by
>> > - * the "luo-abi-header" property in the LUO FDT.
>> > + * This structure is the root of all preserved LUO state.
>> >   */
>> >  struct luo_ser {
>> > +	char compatible[LUO_ABI_COMPAT_LEN];
>> >  	u64 liveupdate_num;
>> >  	u64 sessions_pa;
>> >  	u64 flbs_pa;
>> [...]
>> > @@ -94,40 +91,29 @@ static int __init luo_early_startup(void)
>> >  		return 0;
>> >  	}
>> >  
>> > -	/* Retrieve LUO subtree, and verify its format. */
>> > -	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys, NULL);
>> > +	/* Retrieve LUO state from KHO. */
>> > +	err = kho_retrieve_subtree(LUO_KHO_ENTRY_NAME, &luo_ser_phys, &len);
>> >  	if (err) {
>> >  		if (err != -ENOENT) {
>> > -			pr_err("failed to retrieve FDT '%s' from KHO: %pe\n",
>> > -			       LUO_FDT_KHO_ENTRY_NAME, ERR_PTR(err));
>> > +			pr_err("failed to retrieve LUO state '%s' from KHO: %pe\n",
>> > +			       LUO_KHO_ENTRY_NAME, ERR_PTR(err));
>> >  			return err;
>> >  		}
>> >  
>> >  		return 0;
>> >  	}
>> >  
>> > -	luo_global.fdt_in = phys_to_virt(fdt_phys);
>> > -	err = fdt_node_check_compatible(luo_global.fdt_in, 0,
>> > -					LUO_FDT_COMPATIBLE);
>> > -	if (err) {
>> > -		pr_err("FDT '%s' is incompatible with '%s' [%d]\n",
>> > -		       LUO_FDT_KHO_ENTRY_NAME, LUO_FDT_COMPATIBLE, err);
>> > -
>> > +	if (len < sizeof(*luo_ser)) {
>> 
>> len != sizeof(*luo_ser) here?
>
> I can change this, but it is not necessary. It is common practice to 
> verify that a "struct" is not smaller when compatibility is checked, 
> allowing for future expansion without breaking compatibility with older 
> kernels. I know we do not support forward/backward compatibility in any 
> way right now, but I do not think it hurts to put the proper safeguards 
> in place.

Yeah, that was my point. We don't support anything other than exact
agreement on formats. But let's keep it this way for now, so we can grow
the struct in a backwards compatible way if needed.

>
> Pasha
>
>> 
>> > +		pr_err("LUO state is too small (%zu < %zu)\n", len, sizeof(*luo_ser));
>> >  		return -EINVAL;
>> >  	}
>> >  
>> > -	header_size = 0;
>> > -	ptr = fdt_getprop(luo_global.fdt_in, 0, LUO_FDT_ABI_HEADER, &header_size);
>> > -	if (!ptr || header_size != sizeof(u64)) {
>> > -		pr_err("Unable to get ABI header '%s' [%d]\n",
>> > -		       LUO_FDT_ABI_HEADER, header_size);
>> > -
>> > +	luo_ser = phys_to_virt(luo_ser_phys);
>> > +	if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COMPAT_LEN)) {
>> > +		pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_COMPATIBLE);
>> >  		return -EINVAL;
>> >  	}
>> >  
>> > -	luo_ser_pa = get_unaligned((u64 *)ptr);
>> > -	luo_ser = phys_to_virt(luo_ser_pa);
>> > -
>> >  	luo_global.liveupdate_num = luo_ser->liveupdate_num;
>> >  	pr_info("Retrieved live update data, liveupdate number: %lld\n",
>> >  		luo_global.liveupdate_num);
>> [...]
>> 
>> -- 
>> Regards,
>> Pratyush Yadav

-- 
Regards,
Pratyush Yadav

