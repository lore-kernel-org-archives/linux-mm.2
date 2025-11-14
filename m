Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A31ECE8D7D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6A688E002B; Fri, 14 Nov 2025 14:34:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1AFB8E0021; Fri, 14 Nov 2025 14:34:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09578E002B; Fri, 14 Nov 2025 14:34:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADD178E0021
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:34:00 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FCBA592CB
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:34:00 +0000 (UTC)
X-FDA: 84110213040.02.1876CD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8B5A5C0019
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:33:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H/FCBFq3";
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763148838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cr/M35xOZt69Rz+1fp2O+fG2oD8FG7boktVqzDGyi4M=;
	b=fLMD6WV3o+XjYk4z6r1zsjmB2vicAXHOO1gBC6wMuWgjBfQEKaoydYgNwKkc++8oovOdZL
	ioxb6uc9oc3GN6LF9KA78GwLa9yHwU4M8p49Duf27mOGw4VpTNN9yfJZ7sQnXmdukcTuVk
	h/69lny8XewwXOa26YxzVa+98WwxHkQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H/FCBFq3";
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763148838; a=rsa-sha256;
	cv=none;
	b=Gu1g3heqni3rzp+kEJF7Kpkot7c1SFlhk2/8UC8qtxID5gL2ZQSfjvJcVhfhJPf+e40Sbo
	IpbyFp0+BVBBPucEMdg+cnzjZEUWHK6SKKqd2QlOJ69ahlL6aEqqzk6OXNl0WwJ26nIalJ
	in+VmXLY6xEc1vL9Apj4SDZVjWNvj0g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9391A42E49;
	Fri, 14 Nov 2025 19:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897F6C113D0;
	Fri, 14 Nov 2025 19:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763148837;
	bh=FZlWl6qWs90L/x6LrsaPXbIv40QuDF4Bq+k9+9iwvHM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=H/FCBFq3BK4sRDRlJS4qxqxbkJ04z3EUmWnL6nfcRTAYLPQs5LsCcx0P0FWqIeXBf
	 EY4XCIsjOOtT/LhGn/3+JTNCV2epPhgMYFzcg/B7EJmKYtDDzrxeYBgNF8+EcMvmUu
	 p4kdbKdYGEPxNOhITYECmyOfJXmBaBqcCx/tDY/UOy66N/SiDku0pMAT9lM72+Wdgt
	 pnwpKrcyu0OrIYe74l6RQoS896GojkRIgnZtH7zJ1duMnhTVAKcHb5HwvRcgBNzeXc
	 SzfLqHK/QJEkleADVWXk/ByhAxt7eS4kOINLelj8lcf82ZQmCThm5QSwxz2/DNffuf
	 b/rZhOGN5SPqQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v2 05/13] kho: Verify deserialization status and fix FDT
 alignment access
In-Reply-To: <20251114190002.3311679-6-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 13:59:54 -0500")
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
	<20251114190002.3311679-6-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 20:33:54 +0100
Message-ID: <mafs0ecq05rz1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 8B5A5C0019
X-Stat-Signature: p8nrqta9g1fmtsq9efaite3kxwthy9m8
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763148838-880531
X-HE-Meta: U2FsdGVkX18BltBylQ9fZNKb9bivJ4OGArCHmDxxQ5baR1lBzwyc9ZfsHB/AYoFGEzT/r0xAeQPJtTU03iZJxsgY1+LMBbzouuA52dAup84CPAzKqPdU/N5dvW/iP/epWOwcLPMm2TGYsUSvpBVR7m3oyX3VyZs7O0+xyj2vD7ubjcKd0N8KmuCF9kN3x4OOSZ71NpmZF4asepRSDChWdCYcnANYpwo/aHhQLDfeSfO6242zRFVnpZDq/fsyMD3zSwKW421xc+0M9Dl1sBng8pHO+HUiBXkzFE9K2SB7qq28Qh2nWfyPsb3lpl9kAr7d1p+Q6hT87WdHXh6hvlDrqolvH+wCHG8ST3u/c+NCUrYuP+nUXUjUUeZaTSYpNsTu5SlcnI+ZA8ov6QGVwnQuajkZnnIlhJkwdFGia7sNchirh+2kio3b/LJCkbqFKAbqVRZBrtNv7qa0XA9vcv5ERt6tqx/1ZZ4S+ewYLvVpbx0BmT81TNAgP8THof/ezm05r/7k7+3YxBfdQxSxBwtCa8pZxWeKgXyFVTYqm/7TcPb6DvbieGPmSoOLU7upKqCQ5iGdL8u5HO4kuQdRR2LcU1IDC7LwrKbiPVzVk+qZRwdcZbyU+8OseaSqNOD4Gedg1yqUhuRkjcUqtWR91o7rCZsIx5VGPGvyVsmXgV26Qb//7xsSlPxYJqUreG67jSacn1NFs8R/Krkr0eDoksMLJRDp27b8y+KW1Tnpl20/+lw3dEtuL6E2b4fzZzOHMXyivkxR83skGAVB43L+uF+meiq47A7BPYHlhFhzHVroFyvt48HtUWp0UB5cgKN6D3dSyBdrj9QdRP9JbdfCyoD/2AssqoAK6DQTphbIB+yaqEWMNwlVryYM8Do9m0z8RR9zzwWM23iqn2dBK4eIIhu4nUAd9isuZbZ3ygptsIKswmiRKPw2UA6NZcyK2s5otmxBigEjWtrulvNZFan1G17
 q9AChX60
 rN4WCNTrPJq9bbvFVjQz0SdTctD57kau6yEyBuoKb2d0q8EgOT+cfO/nbJEAg2NGFuGmbq1trdm2o2b9N5Tk1rFDTuuglVn7xm4pWlQ7YMC9ITstZn/SYV0fh4U/zYKY4/A0D0VhDt4zuEIq6ZbwNiW1I/G0tuMKZ1UUxim1vsMALvy8Mw7xsHE+ZLvZeTFqx5FbMXafvFJI980Hc1C4QBdUd3d3k/kAmmY7fG3qIgyO1BDGzd3SQXJWfBj2Ogo6zZlIOWZ34zOGQCcESYq+x8CqUug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> During boot, kho_restore_folio() relies on the memory map having been
> successfully deserialized. If deserialization fails or no map is
> present, attempting to restore the FDT folio is unsafe.
>
> Update kho_mem_deserialize() to return a boolean indicating success. Use
> this return value in kho_memory_init() to disable KHO if deserialization
> fails. Also, the incoming FDT folio is never used, there is no reason to
> restore it.
>
> Additionally, use get_unaligned() to retrieve the memory map pointer
> from the FDT. FDT properties are not guaranteed to be naturally aligned,
> and accessing a 64-bit value via a pointer that is only 32-bit aligned
> can cause faults.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

