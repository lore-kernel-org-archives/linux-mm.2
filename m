Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC013CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 21:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9DA56B0401; Sat, 16 Aug 2025 17:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74D06B0405; Sat, 16 Aug 2025 17:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A976B0406; Sat, 16 Aug 2025 17:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C32446B0401
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:02:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 873AF140504
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 21:02:25 +0000 (UTC)
X-FDA: 83783843850.28.86C7BEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E371820010
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 21:02:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b7ZG2hNv;
	spf=pass (imf13.hostedemail.com: domain of ojeda@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755378144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0UQWu3de9suKnOEGfEXbHMd8BmUyI3niGL7+BrpRokk=;
	b=A8pgGGFAtD2JRf11xZJBwZslHp4o4GP3oSwPQcq6xJ+dJYncfOU/CmPHxBW6Niv8jS8u88
	QUQ17Wr9M8fPEG7osXzg2Hq72q4Hd3+RTpfBxPXbjL9x0a+7BTOM669IJ9GeXw87Bp2LjZ
	gOAVSvsqOvK3h0bn9By8g/nPQYEbVb8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b7ZG2hNv;
	spf=pass (imf13.hostedemail.com: domain of ojeda@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755378144; a=rsa-sha256;
	cv=none;
	b=5ZPcXx8LGOd7Y6z3wdxLNHD1kBENDrUmRyWoMX5wLJLYcVxTrjqw2hKwzmggIvNAD5fnAD
	hC5lok5rc6uif2YUuAzSYsB9hz++al3uAEzCWgcZ10IRs6VjPY3WVXz3mO0zUmMvTpCi/B
	RVFt3FK7clg7ileuJkKWOhoENj7D6Sg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D6364576F;
	Sat, 16 Aug 2025 21:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F43BC4CEEF;
	Sat, 16 Aug 2025 21:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755378142;
	bh=LPy5e6n6vR1llHOo2EO24oNety9Sy0DZL4/9aZBMZcA=;
	h=From:To:Cc:Subject:Date:From;
	b=b7ZG2hNvVEGsmVZGqFok2B5Ut3JlrhAm0TEb5kcPlq+2FoXEJJwCdOWjPw+OogiC4
	 vHZCCukv1MT5BZzVgAvQpzjkjzrx49nFqAhLInIGTnQFFDtEJulmp5F3v9RW3DwBYq
	 I81Ytc7XJgOdOp8G3SYBA5d8WbeLC+ycWpljp3efVXzvpeZsg2g7cYT33UxaZequeo
	 5zji+Z6frzPsKCjU/n36YsCIIiFxREQJza/yFLhnvDW7qysKMCoahLpV+LOXJZj1gG
	 CwSpw7Ou6R42UU0F3yPH6duyny1UyTixAS91hV8UNblX97rHL3Of/wYXXgQuiIJHFy
	 q1czCwufE8txA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	Uladzislau Rezki <urezki@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: alloc: fix missing import needed for `rusttest`
Date: Sat, 16 Aug 2025 23:02:14 +0200
Message-ID: <20250816210214.2729269-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E371820010
X-Stat-Signature: fitmaizxcoz94gyp8bt6xgtcmzzmyihu
X-Rspam-User: 
X-HE-Tag: 1755378143-889011
X-HE-Meta: U2FsdGVkX1/AOR70TmR7t79tDju16Q9f+ZS7PSjpUKvkpYaCepw0EJi79ZvjmeoeIf63Y1atJ6U8FxHMDq3PWpMMI3t+aTnUfh+Av3p/XMq3G86MFQ9dVE0g7Nt8h6tgC40KxzOQ8uSItd3+dwsxW6vsgto1ajodlimxdWqzDeHeppSvsSVI8LlP5gs81/J2kPBqaUMfyvYF5K8IRFFlxoWGIPrPU9ZBxyWNBysNh5l/fzFcQKH+zz1dqC4DO5hDRCPkRhbhSAIxfeczdTu378HC5yL3pQXIj8NiKlh7zS/PhG4Gahv4cIoSXx477zcJBkGweVOZCB4VexIModHzwGFIQNfd1cWkU8sXUBxFHR5rQN3a+hHWEJoMD/O5kFklNEGnrdV3mPjwZvbCWfIj4g687Crq4AS8vrBZJgq9zBLamxW1FKj3Aob74hqa6gAzwKHZO8slcXPi/f7NGQU0Q779PJWhmklY8lePCblxLVuiAdBNfqswAolKl0n5DyuYQ5pFSs79YP2i6vCmMUuhduUr6P/TjvWuVLkJrf/ZAIiGnYd+4gp22b/0n9WiG7o3uH1kpY3hT+kKW3PoBn65Om0vGNNhmQMj6/BeoQMSUMsNYMRvzLlgfpxJXCwEDhg4PBVhYPEd2CVjxSHz9GNBEX4hydMa0J4uODqJdE2J8qx/vekUMTx1eXpjkvANkFrTied8W40NXfT/NSeyDi5FbqttLrPXl2VYU5GJDHP7Oawq70BtwX5OegdJqXFNF2fTGgtNX3VP+E1i0yaSfne5eSy0vqWOzUwU77qdZuEJ0su3MQZLzQNwELx0VJv0andfczgZE1mqihI2ebgZqxBWTU1nJKO9l7s1wgNkcSaQNmw8GZKiLQFW1AEaMm2kI9jG+Y5JkwlvYHIQ6UoV2loBSu8K1q1MRzuS3LrjFrbvKBelWUC5zUo/mVBYO9vUMIPQDgPH3efM6tOcbgcYH3t
 VLf1nOge
 ghEHbzLZN7ayFQQhoKwNGQMnrv5ywoAWNzsFWUepQWFALp3d8WgBvfHaz/K1TadP/7m6lvFFvMMUdRWmDzKL0cGsTcXAMsG3yg4Rl3EMY07smGU4xsx5LlDr9ftWCbbeNMjJVPdbWEzMNOJ/e55Wp6GjRHggzPEDykUHEUZR2rQJUsY1IrxcBLr2DL7U4sgOUbKNhzEjMTbIvRF4UIBkdlRBcpnDxmjlMY3lkcDM9iJHd5lHOcEqqdmm9KI83e2bJLXd/dh6Moq+r0PBVE6WvOx9lrajXqTPyswoMXxPusiUK78U4vtaya1UasfcZ0F0ijrYvP0jDdag4bRukDCtwBo8n7HmDXj2kdvlMZMAb1rEYT+AdEtaZ7+xJoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is a missing import of `NumaNode` that is used in the `rusttest`
target:

    error[E0412]: cannot find type `NumaNode` in this scope
      --> rust/kernel/alloc/allocator_test.rs:43:15
       |
    43 |         _nid: NumaNode,
       |               ^^^^^^^^ not found in this scope
       |
    help: consider importing this struct
       |
    12 + use crate::alloc::NumaNode;
       |

Thus fix it by adding it.

Fixes: 8405eafa6e94 ("rust: add support for NUMA ids in allocations")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
akpm: please feel free to rebase this into the patch directly if that is
simpler/preferred.

We are looking into removing this file, possibly this cycle, so it is
not a big deal but meanwhile it would be nice to keep the branch clean
nevertheless.

 rust/kernel/alloc/allocator_test.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allocator_test.rs
index 283c02376458..13435ef8e652 100644
--- a/rust/kernel/alloc/allocator_test.rs
+++ b/rust/kernel/alloc/allocator_test.rs
@@ -9,7 +9,7 @@

 #![allow(missing_docs)]

-use super::{flags::*, AllocError, Allocator, Flags};
+use super::{flags::*, AllocError, Allocator, Flags, NumaNode};
 use core::alloc::Layout;
 use core::cmp;
 use core::ptr;
--
2.50.1

