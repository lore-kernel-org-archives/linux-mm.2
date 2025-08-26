Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA0CCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E8018E00D0; Tue, 26 Aug 2025 08:38:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BFE18E00A8; Tue, 26 Aug 2025 08:38:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FCA18E00D0; Tue, 26 Aug 2025 08:38:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5AA8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:38:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA5B05B748
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:38:24 +0000 (UTC)
X-FDA: 83818861728.21.27F955F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 63A27100005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:38:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0duExL8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756211903; a=rsa-sha256;
	cv=none;
	b=eMni9ClVfQ8ZM4/m+OPcOCjTYJl9uuIn8lUO5IqQEovBICynJ8aKeHAjTbPupRrQrru0ye
	BrKUuvTTQkD4yafpfxHK5WltrylrcAHw9cfsHHWNGd/wcfciQ0s7qjW/MsfkI5N7MZ9D8n
	LmCPeMAbZQvO2Fb49aekuDQNkQpEhI0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0duExL8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756211903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ckzOIvZ0fWGCSpnmH5Igqs2rcFJvgg20XUT5RZD/dHM=;
	b=KjNaIktwb+UydFFfWxmD73ZIHgHBgc5/v5Z4QIVcff6qTNx8+YGUOp6z7fcxIlqdeCZ1WY
	3nNbiSiL9bnIRjbabtssXpCaYXMoCj3WDqGsD9ULwDO6N/0yJRLVEoa7f1ITIlIfF/1Wg/
	83FxkGTj1Qvaz8lxjdSglfzKUUmaCg8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09E5F4383E;
	Tue, 26 Aug 2025 12:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F13C4CEF1;
	Tue, 26 Aug 2025 12:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756211901;
	bh=eMENLqxHzQQRExGaCUyCzfHRWShUoYDQAQ6JsPXHglU=;
	h=From:To:Cc:Subject:Date:From;
	b=H0duExL81okpSlnLoxs1EG1AhCa+yp/45AQAWEWwP7Z2oxsc6tdDlyY0XRd/cUfJa
	 Ji51alkHHqhzK+HtwCMwYnCp92/k3M/9XW2NRqE520tCPcw4cn0Z9krYBhxTdNHCBh
	 l6bVATbp/FW5SxW9sO3Qmte/6N2zttf+cKphDOMiw6KpNDbJmSivqK2gy2eShjTPvs
	 Gjkhrx9HzO2jI3/HFUGgFUkYsM/Bs/uiysC2YC1hnyHVAkXLc2O83Y8gtcri8bEMZu
	 +ls7hgta7LSPO3y0spLUHYnEC+ft/XgXV5dYYhHRhxxJ6Al59rDKP0RP86i8busKmm
	 FOr/DLHl24C0A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kho: make sure kho_scratch argument is fully consumed
Date: Tue, 26 Aug 2025 14:38:16 +0200
Message-ID: <20250826123817.64681-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 63A27100005
X-Stat-Signature: ta364geshwtqnoxw83tb5qefxeq8o3nx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756211903-393479
X-HE-Meta: U2FsdGVkX18KOH1gjSEISWliWVZHwZr3C9qRLc482NkvsFfY2jAR9zIKu1MHjp+Esf2jkcPyZB6bGjmeSax3f7OH4Q0JnArYI1i8U3RkB6lMeKLb3rRm3pi+c8gXTbdV8f0DE+sdEilkvqSQANWUvlQeKyFtE19rxsMs0TuRmpOOBXkU2cMKFETEZh3zBfXy4Lb3S2p0jbqVoqiLd/DnGDSMCfFHh8batkFZ3dWjcVBvv5l3Qg60l49C0wZqJsC2h13diq0/LEHxpCKT+X7F1hukeZWWz61zVgAvFqD99ZrWsFcf/fRkZ7LT9r7Ca3Jg+yVD+R6enTr+hOQyYLt1gXAElNfi7hNncqG34tUqoM1JeG1dH9zP4N5FmKOhvH8524o76f3fWy8hq3nh0uRoU1zEHeIM1k4jO5TMuwlspfXwuCb7VeO5h0A8EvG8cuCzfoP+42BxlCyv9kKIlLkh38ZElliDWksnA4yMf0KxBfZioYI8hmnslVdi0j3sNMqXH4VCWOeZB0DOS/+RWv+R6ngL6EMGlBy/ZxJm77YGON4XeQZc5L4LPcakPhuZdQuKXnjUxNIy3HrGDmPbNXo8lSI8rxuY353PCJGvdQr9d0T+79XdFLs6ohrU43DstGPHL7+fmU2IxZrOXLYTxvwfrWJttJRI5JAlSBy9LM2+V4G4gwubZ8v8/SzVKknBdeA+TYIEWJsqgo+OMtgq0Lt7x4swJgmZCJvZv62aZ7LgvXHxkQB0FKVV5gx2RR3VS+kGQg+ckX3YD7BuiWcVIXwbxOz8oibXAL7Jarxbt6wuXGuV7LP9mg4FNffp2BrkPKnTt7r8WIWkBWET493wA1fe5DEt5jRaOk8KMi194PyQbF3hUDJwz4dD7T5a/FXRPgz7kJUxyoBY7oD4prCL51zdTPiTITeVRo3i3J4kLnQHKPzI/5vUvk1xne0rAzZWqkQn5Sq/JyVuhNFi7C9iwQl
 XU23b7k2
 4drPqIli443iQZQI3X4oz5uRDTlafY5DhXbsitCiTbMFcdHfOJDLgmQxlDo2bxoNOwIJ2TNTJUY5kqs/1qTl0EPetvfUEHHfyq8ZTYmkV0R0PopYj4PDUY74BWuoWHQhHhqQCMvCMiejaF+M7b1YAzW0iP/rCCl0ljgqjO9Y5AvLdaaza/G+zaKAGleCp/OYY5aSQW5eYltkxSat26hcWiCV8vF1bB6KIUP6N6fvlE6iUBFSgu+dk8n7dFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When specifying fixed sized scratch areas, the parser only parses the
three scratch sizes and ignores the rest of the argument. This means the
argument can have any bogus trailing characters.

For example, "kho_scratch=256M,512M,512Mfoobar" results in successful
parsing:

    [    0.000000] KHO: scratch areas: lowmem: 256MiB global: 512MiB pernode: 512MiB

It is generally a good idea to parse arguments as strictly as possible.
In addition, if bogus trailing characters are allowed in the kho_scratch
argument, it is possible that some people might end up using them and
later extensions to the argument format will cause unexpected breakages.

Make sure the argument is fully consumed after all three scratch sizes
are parsed. With this change, the bogus argument
"kho_scratch=256M,512M,512Mfoobar" results in:

    [    0.000000] Malformed early option 'kho_scratch'

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/kexec_handover.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index ecd1ac210dbd7..a90d55121a7a0 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -446,6 +446,10 @@ static int __init kho_parse_scratch_size(char *p)
 		p = endp;
 	}
 
+	/* The string should be fully consumed by now. */
+	if (*p)
+		return -EINVAL;
+
 	scratch_size_lowmem = sizes[0];
 	scratch_size_global = sizes[1];
 	scratch_size_pernode = sizes[2];
-- 
2.47.3


