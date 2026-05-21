Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63353CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FEB16B009F; Thu, 21 May 2026 13:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFAB6B00A0; Thu, 21 May 2026 13:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E196B00A1; Thu, 21 May 2026 13:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 69A006B009F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:45:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B7C9A06B1
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:45:13 +0000 (UTC)
X-FDA: 84792153306.16.C0C7FF6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6A609C0007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:45:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="eBU4r6q/";
	spf=pass (imf28.hostedemail.com: domain of jani.nikula@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=jani.nikula@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779385511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JkK65RDtR3mLEPhqVTmKcBBfGABseq6VrGC9TbyXzOU=;
	b=N+FwdOTN6IFkoMDUHJitXi1Amf5gO7aL5W3RvC91eDRbtVkwWDXYwKToTRwDr54k6MNGE5
	1qaPxY4gX1Eabw5FpCejTkC+iPbbw8TAePJEdhp+TgQ/ZrSaTicESVXAbokubdNnCP4Crb
	fhbs+pH65YJL7MNlu3JiVC51eHEOcZA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="eBU4r6q/";
	spf=pass (imf28.hostedemail.com: domain of jani.nikula@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=jani.nikula@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779385511; a=rsa-sha256;
	cv=none;
	b=tmFGc06RGVhd0iFh1dfVJDhhwSLJD66RJ12SOYaWukKkAscY9XCqvYrzzTi/eKvCmTk4mA
	axzaZDoEPfYt9RLJAMlVSvk25iX00BjadyPEVkqzXwyU/9gFlfsH2oXk40/VGSddpKt37P
	Iqzn/k/EJ4dbpmvHwJsudJc2cdbPL0g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779385510; x=1810921510;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=sU3q4ei5VqXFeemg2pdBcbpXy8Z2qTRY4hHBwMHyr+A=;
  b=eBU4r6q/Pfly7X1yJqCLEHmyhpQJlV2crbXifUpUKCUV7dlTkEqmae1a
   AKceYkxuO1zsrSOCHkjdDFGmvavXdwKnO5at9Ha77MIU+4AQNzCNl91t3
   gn/G98vXvWp3nOTNJa5kS7jQCy7kdG5BgwPqzrtr5jAam2wVSnH/ecHI4
   GxTC6OsY/Gte2p/rlOIc+UMKrRW/k2kpLoDax7m+oSw1fpBccCyzualiP
   Sn6OUbc5OrTCm6t/8e2kHMIcl3aWYHH6VE2JhwXCsGbyIMLanNaefDSrT
   3Fx6S9FQEF/3FNAkW3k8tLsaFhlaDR13eozETdv3PTBgoc/MLi7Gw7BPq
   g==;
X-CSE-ConnectionGUID: pGGjq1xlT2WTzqMe4+N+Cw==
X-CSE-MsgGUID: BF+cZjgyQlGufgxfU6Lqqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11793"; a="105773585"
X-IronPort-AV: E=Sophos;i="6.24,160,1774335600"; 
   d="scan'208";a="105773585"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 10:45:08 -0700
X-CSE-ConnectionGUID: sVvxl8W3QX2Yx8AK13BLJw==
X-CSE-MsgGUID: XZM0S5M8QcaTj4wM3UKoHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,160,1774335600"; 
   d="scan'208";a="236347421"
Received: from hrotuna-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.244.167])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 10:44:41 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <kees@kernel.org>, Pengpeng Hou <pengpeng@iscas.ac.cn>, Petr
 Pavlu <petr.pavlu@suse.com>, Richard Weinberger <richard@nod.at>, Anton
 Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, "Rafael J. Wysocki" <rafael@kernel.org>, Len
 Brown <lenb@kernel.org>, Corey Minyard <corey@minyard.net>, Gabriel Somlo
 <somlo@cmu.edu>, "Michael S. Tsirkin" <mst@redhat.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Bart Van Assche <bvanassche@acm.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Laurent
 Pinchart <laurent.pinchart@ideasonboard.com>, Hans de Goede
 <hansg@kernel.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Bjorn
 Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Daniel Lezcano <daniel.lezcano@kernel.org>,
 Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby
 <jirislaby@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Jason Wang
 <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio
 =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>, Jason Baron
 <jbaron@akamai.com>, Jim Cromie
 <jim.cromie@gmail.com>, Tiwei Bie <tiwei.btw@antgroup.com>, Benjamin Berg
 <benjamin.berg@intel.com>, Ilpo =?utf-8?Q?J=C3=A4rvinen?=
 <ilpo.jarvinen@linux.intel.com>,
 "David E. Box" <david.e.box@linux.intel.com>, "Maciej W. Rozycki"
 <macro@orcam.me.uk>, Srinivas Pandruvada
 <srinivas.pandruvada@linux.intel.com>, Peter Zijlstra
 <peterz@infradead.org>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Vinod Koul <vkoul@kernel.org>, Frank Li
 <Frank.Li@kernel.org>, Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen
 <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, Alexander
 Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry
 Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 John Johansen <john.johansen@canonical.com>, Paul Moore
 <paul@paul-moore.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn"
 <serge@hallyn.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Georgia Garcia <georgia.garcia@canonical.com>, kvm@vger.kernel.org,
 dmaengine@vger.kernel.org, linux-modules@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, apparmor@lists.ubuntu.com,
 linux-security-module@vger.kernel.org, linux-um@lists.infradead.org,
 linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
 qemu-devel@nongnu.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
 linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-serial@vger.kernel.org,
 linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org, netdev@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 10/11] treewide: Manually convert custom
 kernel_param_ops .get callbacks
In-Reply-To: <20260521133326.2465264-10-kees@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260521133315.work.845-kees@kernel.org>
 <20260521133326.2465264-10-kees@kernel.org>
Date: Thu, 21 May 2026 20:44:37 +0300
Message-ID: <5cd0c8dde3687d0aea765f2f21f5e1cd8ba83028@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 9c3w5kwhd99ik87whsbnaximqbf3zw6e
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6A609C0007
X-HE-Tag: 1779385510-727134
X-HE-Meta: U2FsdGVkX1+TNkcNzS6B6wCuZSAZNJ0lRzDSyXWnLzkO3NSdX4kBl7u3fN5XwUD2g1X7lOgqki3GZNIMfcK1eACCd9SdndP4tecVC0PUN8VL0R87MZItspsnZpnouAM+BvZL/6UAaiHfm5c9b8mEjeDdmQMggQAcffItmtxCXloTElvGOoU0TY6gpvof9sp9RXBRfDag0cMrHIkC5LTVYuQAAvCqC5waq9588sCnLoVmzvbQ7wD8yVL3almJxX0GKWxNSZCOWs+NtZ0D9S8RnEypSNLQSjQ+97TDpQjCNqGtNn8/olcy0Os62VQ2989JB9smqDjmmsETtGffrBq57+HSr730HTIViUXjbAhV2+a0kovzmLrRCLX1EJC3dWS/gBiX7M0a4WRuiEqyp1bZT2T8Y7gb60CQmDc/nPgvLmQjpPo9+qn8V1sNPDkEIkYK+SgCePk+j3j9ftKNCKWNmmBu9qAz/J9VLnDkNkgoTL2SrF+bW200uHSiCRhidAa3whMn7MGy9hXhCrpja3uFUp144+jBJf43X0ihGAU3MkfvWtaGrUOjrsXOHkrxatNu+Le95O1nWagrlA7AOOrDFle8sTKeAiZFkSuHH9gJHyD9e7jlLFwUh3nQVnlN2Qg1Rb3gRQdY65UF/suCa8F8U7AEi1iACIFKQRU+3CBcNwnIcym0s5SaHf8hUcb1terRunHiMUK4stwEeNXIdLFMS8VgeOTxbYodwqojTktC38mD53kkFlfHO5kkaS8PGJI3I6U27rgUU6+g3rW9DxZovcTbx981HZCJ/T1/nu1V+qW9nHy8WjvGTzADXLerYwk039Xm97WA3q+BSe3j/Na3fGWP3zXdWgkURsreGFMWnl8UMKycyA5uNfA5EquN8uG0BOEjEc9A8D00uPQTLzAf9vPM/nsEOXUV7QgNRa4Cs2z2KQR7H1iPSO0VPfEAFGFsJEWdyGMgP1YBgovSufW
 7RJupAJ9
 bOGL0gkiuAccQQzN/Wlr3hAK+lEiy/myAEZAMzn3Q8ojWWWTdRqLNzG0k+BpKYgRizfE//d/ovrVVKaP5Exwto8TRBt8j6MpnvxwTEsScIlWmcdb3Ri5+LKUvm2DZ/87Vsf+HEjW8Vvd2A6CD0hfiQACQTV70NOsTIxQlj+xo1Kb92aY50+VHM9Yu7EQQqfLnlybj8Qdg58vLX4e+MY+pb70Q1GEUu9yqaATT7HRAK9h74nV+0IK6ffzYo2fHo7FD4oBJseWhi+nUd5+cLnlOz5fVMojfkMNcH9vSeqY+OWOt9k+aFDt7BCzzPEUtlmqvx3sxbLD3ypGtX+0PnxPR0Lm6OTqwRQTL7Wy99vnuku9B/HZXZww8sIVxq9u7aYJA41zJUeSi/ioP60MyqRUYw3emRtlX9+HulwbeNKCM/OV4qSzscYH0urIOBSun/KPgw3Tu5DZ+xJ/8t4oKjFy+eQhYSFGTZJS0ljAYmiyHrONqj9yuOJA2QPVdNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026, Kees Cook <kees@kernel.org> wrote:
> diff --git a/drivers/gpu/drm/i915/i915_mitigations.c b/drivers/gpu/drm/i915/i915_mitigations.c
> index 6061eae84e9c..99cb38f355b6 100644
> --- a/drivers/gpu/drm/i915/i915_mitigations.c
> +++ b/drivers/gpu/drm/i915/i915_mitigations.c
> @@ -95,33 +95,37 @@ static int mitigations_set(const char *val, const struct kernel_param *kp)
>  	return 0;
>  }
>  
> -static int mitigations_get(char *buffer, const struct kernel_param *kp)
> +static int mitigations_get(struct seq_buf *buffer,
> +			   const struct kernel_param *kp)
>  {
>  	unsigned long local = READ_ONCE(mitigations);
> -	int count, i;
>  	bool enable;
> +	int i;

I'm fine with what you have, and I can do these as a follow-up later if
it's too much trouble, but I suggest something like this:

	const char *sep = "";

>  
> -	if (!local)
> -		return scnprintf(buffer, PAGE_SIZE, "%s\n", "off");
> +	if (!local) {
> +		seq_buf_printf(buffer, "%s\n", "off");
> +		return 0;
> +	}
>  
>  	if (local & BIT(BITS_PER_LONG - 1)) {
> -		count = scnprintf(buffer, PAGE_SIZE, "%s,", "auto");
> +		seq_buf_printf(buffer, "%s,", "auto");

		seq_buf_printf(buffer, "%s%s", sep, "auto");
		sep = ",";

(In the printf the sep is just for future expansion, though I don't
expect one.)

>  		enable = false;
>  	} else {
>  		enable = true;
> -		count = 0;
>  	}
>  
>  	for (i = 0; i < ARRAY_SIZE(names); i++) {
>  		if ((local & BIT(i)) != enable)
>  			continue;
> -
> -		count += scnprintf(buffer + count, PAGE_SIZE - count,
> -				   "%s%s,", enable ? "" : "!", names[i]);
> +		seq_buf_printf(buffer, "%s%s,", enable ? "" : "!", names[i]);

		seq_buf_printf(buffer, "%s%s%s", sep, enable ? "" : "!", names[i]);
		sep = ",";

>  	}

	seq_buf_puts(buffer, "\n");

>  
> -	buffer[count - 1] = '\n';
> -	return count;
> +	/* Replace the trailing comma with a newline. */
> +	if (!seq_buf_has_overflowed(buffer) && buffer->len > 0 &&
> +	    buffer->buffer[buffer->len - 1] == ',')
> +		buffer->buffer[buffer->len - 1] = '\n';

Drop the above.

I.e. keep track of sep while printing to avoid removing it later.

BR,
Jani.

> +
> +	return 0;
>  }
>  
>  static DEFINE_KERNEL_PARAM_OPS(ops, mitigations_set, mitigations_get);

-- 
Jani Nikula, Intel

