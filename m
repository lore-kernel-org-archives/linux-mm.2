Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EB7CCD6E5D
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93D86B038B; Mon,  1 Jun 2026 08:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6AF86B038D; Mon,  1 Jun 2026 08:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D816D6B038E; Mon,  1 Jun 2026 08:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C61D46B038B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:39:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98BBF1A0639
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:39:58 +0000 (UTC)
X-FDA: 84831300876.08.6C5EBAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 033BB40008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:39:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c7aBDC/c";
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780317597; a=rsa-sha256;
	cv=none;
	b=rhJ0cDRFwWEvImcbjEA7jc7XUPaL8W93sa4o9EjrLR1Sg+NeSqjg7+k6LqaCUJzOpNDvRe
	bntUz+pUIBDn2eBEIIzeZ3l/VrgeVM+mA2C7UuC1wLg5Q+kUCELmd8cVdN7q+ZjZz98Nbx
	ijZ+tRQMAOJ1Hn09HAaIPcLgWvXR6QY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c7aBDC/c";
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780317597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMHn02Tjy2SdQBVIwA3Bmk2f/2F1IAnksPozdoamybA=;
	b=COkk8RN823TvOm8ztUpTctOtXRAd9op9KW7BFb4uOdsErUu4PF9eH1kxbP6bzqxsAr6aNz
	b7ZSygF144dGzE0/PfXpdm/l/j+L+0AXSAfre5amBRBBQLYwQAlmnuJXviebHjNKbQSd7e
	5cbHXRh06VruxXRwR6OdfY2rZlRkFvc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7874660018;
	Mon,  1 Jun 2026 12:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5071F00893;
	Mon,  1 Jun 2026 12:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780317596;
	bh=GMHn02Tjy2SdQBVIwA3Bmk2f/2F1IAnksPozdoamybA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=c7aBDC/c/MWTX0ZGZ6TLVaMpVltABlGICOm8LKMfQgFNhl+1IZoGLUbEydpTgi5pI
	 HmVzxJN+Dy7AcSDN2RIfX2ahy8aM5ncR//wi1q7FZHQ18O0DsYTQtZMJuZ1qnCN9i0
	 bZDr9KBOPViV0PTwS7B9VMqjnY96NzToK2e7R2pQlILeBqTtoSLkxsqqi4nfAxV9NZ
	 A/sqxHNghKzXKoikgpCDiYrX4O9OpZgcPZkFL6fOFMBzd+oIj6Y1teDGq9BRz6V+5/
	 p4J4GxI2jnDB6u1BeqZTp+zVGbXkE7DoG0kZHG1WMeeCEvmNnJuAPpATRC3MS34FHe
	 IvGv4TMMeYKtg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v4 04/13] liveupdate: register luo_ser as KHO subtree
In-Reply-To: <20260530221938.115978-5-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 30 May 2026 22:19:29 +0000")
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
	<20260530221938.115978-5-pasha.tatashin@soleen.com>
Date: Mon, 01 Jun 2026 14:39:52 +0200
Message-ID: <2vxzv7c2fn8n.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 033BB40008
X-Stat-Signature: 9idtq3jmwht9n69rh7fn7j14gt97ta79
X-HE-Tag: 1780317596-547346
X-HE-Meta: U2FsdGVkX19uO+ESXgTXbncnzS9aoF+RRcnTYTJdkceVKYXrGjFwg0rEBk6UHZsard8i+0oefCT6dXHi6fhdUTtnsABjELNU6VHdI5ODBEl5wS3l4Bu4P/v//X1qU48mtPbEOt6R3yoPnbRWpj3CoJCpSRctbJRyIitjpWs1DFUDF0nd0OvX/ukrFtVe4wYd8EhMDzki/YK6sZO3V1Ec2fqElnDg8z7KavhQsND1enXCVpChn4JLcQ56TiWggdswBf23XjTbH1iHX2BB+Gx3q70ZkpzgNUDRycrcauVVoMXSkyVLv0yQ8xJ6yd/PYSHTEDG0h6wsLMKFTjRyml9vJTfoMjPeGICx4mNpn1LTnDLl0P2TPAc8JrybjYFQHZVDZAt/Phu6oSgbvtnkRfG7zNwNtvbRVDnejdsy95Vh3H5/PT1/lC3m/9LBpPcPqzjdpopMSt+zi5vzUWZgEAzi14tmqiSIKtrgwm48Y23NhxnetIXlJj9gyLG/89jg2MkhRV4sd577rWZ5WPByGTUq3PJd79cAge5Rh4yxMeL0XXBK09tPaaYe3BddL1ZypPzSblhn37QCeC68noCtlKx0TXG4q/vjkOoBtxtP2RYL6P+NpyU2WyCkgvnkl+qiSN0SiadhkujEsxhT18xcKFQYbypxDfXG6EUEV6IFM52Q8oFPlCHxFl/Up65x9Mm50UK/XQorLfUUBeA102aQDwUSQLggS7eVsFim/Y2c/ksw+r+RAxi7FsllePxVMUGDxiqJydkXl1cGaiGqK/WKSVYnYK3FE2jSRuypqS+hPncrbTOASfJZV/1yyUe2aH7vqZWfF2cyi/REIE94ca7g8hbWks5QUnLlTQGW5xhDyQrq3vN7IbhyQZ3kRJXIOWwV1Dj0VpdtpzSC1ufjXczgPY9F3xZC8TJIBLfJ1VIamURgiZcyunrxJih/0McSbuKgHAz82qxpTurXZtWnT6xrywQ
 EeYCGA9P
 vGLF1kQd4uMma4sy7/h75Qm5ljShNbxaCfu8GOWgwo8N6hAt+rReX/e/d4tBI9550bvZLwpsDbI8zq5S0mf2MlcNP0YrJJHFXUUJBBmj6ofwIXEJpWz7ynd5jay+SSlYG20uJUPvYGAd5Ma5D/PATG/M8cBPTG67PaIaX1xqXzpDecp7fltdM0RtyOgVs78imTsl3GB5kFMzI65OoZUC/RKZ+TV1oQ3z6h+N6N2md6Vn/CJryAzrAzOAg+KyY7J3nomJUoH5CdiBnGxzJnf1aD1NhRExwyiB1bqZFkh0k3ZT/qf3qgQ7vlENoE6mV98ZUC0QM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30 2026, Pasha Tatashin wrote:

> Entirely remove the LUO FDT wrapper since the FDT only carries the
> compatible string and the pointer to the centralized struct luo_ser.
> Instead, register the struct luo_ser via the KHO raw subtree
> API, placing the compatibility string inside the structure itself.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kho/abi/luo.h  | 57 +++++++++---------------
>  kernel/liveupdate/luo_core.c | 85 +++++++++++-------------------------
>  2 files changed, 46 insertions(+), 96 deletions(-)
>
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 1b2f865a771a..9a4fe491812b 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -10,11 +10,11 @@
>   *
>   * Live Update Orchestrator uses the stable Application Binary Interface
>   * defined below to pass state from a pre-update kernel to a post-update
> - * kernel. The ABI is built upon the Kexec HandOver framework and uses a
> - * Flattened Device Tree to describe the preserved data.
> + * kernel. The ABI is built upon the Kexec HandOver framework and registers
> + * the central `struct luo_ser` via the KHO raw subtree API.
>   *
> - * This interface is a contract. Any modification to the FDT structure, node
> - * properties, compatible strings, or the layout of the `__packed` serialization
> + * This interface is a contract. Any modification to the structure fields,
> + * compatible strings, or the layout of the `__packed` serialization
>   * structures defined here constitutes a breaking change. Such changes require
>   * incrementing the version number in the relevant `_COMPATIBLE` string to
>   * prevent a new kernel from misinterpreting data from an old kernel.
> @@ -23,31 +23,15 @@
>   * however, backward/forward compatibility is only guaranteed for kernels
>   * supporting the same ABI version.
>   *
> - * FDT Structure Overview:
> + * KHO Structure Overview:
>   *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
> - *   This entry contains an FDT with the following layout:
> - *
> - *   .. code-block:: none
> - *
> - *     / {
> - *         compatible = "luo-v2";
> - *         luo-abi-header = <phys_addr_of_luo_ser>;
> - *     };
> - *
> - * Main LUO Node (/):
> - *
> - *   - compatible: "luo-v2"
> - *     Identifies the overall LUO ABI version.
> - *   - luo-abi-header: u64
> - *     The physical address of `struct luo_ser`.
> + *   This entry contains the `struct luo_ser` structure.
>   *
>   * Serialization Structures:
> - *   The FDT properties point to memory regions containing arrays of simple,
> - *   `__packed` structures. These structures contain the actual preserved state.
> - *
>   *   - struct luo_ser:
>   *     The central ABI structure that contains the overall state of the LUO.
> - *     It includes the liveupdate-number and pointers to sessions and FLBs.
> + *     It includes the compatibility string, the liveupdate-number, and pointers
> + *     to sessions and FLBs.
>   *
>   *   - struct luo_session_header_ser:
>   *     Header for the session array. Contains the total page count of the
> @@ -78,26 +62,27 @@
>  #ifndef _LINUX_KHO_ABI_LUO_H
>  #define _LINUX_KHO_ABI_LUO_H
>  
> +#include <linux/align.h>
>  #include <uapi/linux/liveupdate.h>
>  
>  /*
> - * The LUO FDT hooks all LUO state for sessions, fds, etc.
> + * The LUO state is registered under this KHO entry name.
>   */
> -#define LUO_FDT_SIZE		PAGE_SIZE
> -#define LUO_FDT_KHO_ENTRY_NAME	"LUO"
> -#define LUO_FDT_COMPATIBLE	"luo-v2"
> -#define LUO_FDT_ABI_HEADER	"luo-abi-header"
> +#define LUO_KHO_ENTRY_NAME	"LUO"
> +#define LUO_ABI_COMPATIBLE	"luo-v3"
> +#define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)

The length of the compatible field will change depending on the length
of the string. While that is technically fine since a new ABI version is
allowed to change the layout, it feels odd. I think it would be better
if we define a static size here, say 64 bytes. This way you can avoid
all the weirdness that can happen when you move from one version to
another.

>  
>  /**
>   * struct luo_ser - Centralized LUO ABI header.
> + * @compatible:     Compatibility string identifying the LUO ABI version.
>   * @liveupdate_num: A counter tracking the number of successful live updates.
>   * @sessions_pa:    Physical address of the first session block header.
>   * @flbs_pa:        Physical address of the FLB header.
>   *
> - * This structure is the root of all preserved LUO state. It is pointed to by
> - * the "luo-abi-header" property in the LUO FDT.
> + * This structure is the root of all preserved LUO state.
>   */
>  struct luo_ser {
> +	char compatible[LUO_ABI_COMPAT_LEN];
>  	u64 liveupdate_num;
>  	u64 sessions_pa;
>  	u64 flbs_pa;
[...]
> @@ -94,40 +91,29 @@ static int __init luo_early_startup(void)
>  		return 0;
>  	}
>  
> -	/* Retrieve LUO subtree, and verify its format. */
> -	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys, NULL);
> +	/* Retrieve LUO state from KHO. */
> +	err = kho_retrieve_subtree(LUO_KHO_ENTRY_NAME, &luo_ser_phys, &len);
>  	if (err) {
>  		if (err != -ENOENT) {
> -			pr_err("failed to retrieve FDT '%s' from KHO: %pe\n",
> -			       LUO_FDT_KHO_ENTRY_NAME, ERR_PTR(err));
> +			pr_err("failed to retrieve LUO state '%s' from KHO: %pe\n",
> +			       LUO_KHO_ENTRY_NAME, ERR_PTR(err));
>  			return err;
>  		}
>  
>  		return 0;
>  	}
>  
> -	luo_global.fdt_in = phys_to_virt(fdt_phys);
> -	err = fdt_node_check_compatible(luo_global.fdt_in, 0,
> -					LUO_FDT_COMPATIBLE);
> -	if (err) {
> -		pr_err("FDT '%s' is incompatible with '%s' [%d]\n",
> -		       LUO_FDT_KHO_ENTRY_NAME, LUO_FDT_COMPATIBLE, err);
> -
> +	if (len < sizeof(*luo_ser)) {

len != sizeof(*luo_ser) here?

> +		pr_err("LUO state is too small (%zu < %zu)\n", len, sizeof(*luo_ser));
>  		return -EINVAL;
>  	}
>  
> -	header_size = 0;
> -	ptr = fdt_getprop(luo_global.fdt_in, 0, LUO_FDT_ABI_HEADER, &header_size);
> -	if (!ptr || header_size != sizeof(u64)) {
> -		pr_err("Unable to get ABI header '%s' [%d]\n",
> -		       LUO_FDT_ABI_HEADER, header_size);
> -
> +	luo_ser = phys_to_virt(luo_ser_phys);
> +	if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COMPAT_LEN)) {
> +		pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_COMPATIBLE);
>  		return -EINVAL;
>  	}
>  
> -	luo_ser_pa = get_unaligned((u64 *)ptr);
> -	luo_ser = phys_to_virt(luo_ser_pa);
> -
>  	luo_global.liveupdate_num = luo_ser->liveupdate_num;
>  	pr_info("Retrieved live update data, liveupdate number: %lld\n",
>  		luo_global.liveupdate_num);
[...]

-- 
Regards,
Pratyush Yadav

