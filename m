Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EAAC606A326
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 04:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=u/Gx8aBg
Received: by kanga.kvack.org (Postfix)
	id 026666B05B1; Sun,  8 Nov 2026 23:27:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F199F6B05B2; Sun,  8 Nov 2026 23:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08056B05B3; Sun,  8 Nov 2026 23:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC5CC6B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 23:26:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC8E5C0598
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:26:58 +0000 (UTC)
X-FDA: 85414295316.24.49C018F
Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	by imf08.hostedemail.com (Postfix) with ESMTP id B0AA1160003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:26:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="u/Gx8aBg";
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794198417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SVPjoU02fufplg6UCU1lm8OR+hTiBw+cX99Xog7iH4=;
	b=Iq8uE9zVL9WwzWwZveaJrScYSdYOgNwWPjwxGtU+TI9l2ZIT8nXCpw+3my3BlNZCZbMcb3
	RKdYYAYtbn7qvpSgSe77St9rw8GU3KVmX2Hf3rnEBZ0OHPM6zb/Kzoi9tfcBytjgOKQvJI
	2xHOcceXKME1tUxCKrX2FrOnMDQf/vI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794198417;
	b=j03vvQsMV/tfIuR8GFaDRWivlqwe91Dm1HIDvbih0nSmk2R1M0/WXTdozuIPO+GiRYPEg6
	rKPnshZDCwcwEztOyhoLnM8Xx6Jffijrx0BKQplhiFUan85lF4JoiOTzKEfpVe9Ob1AKDy
	Sbc7Lf/3G4VPy9tkQqPZK6TcBzvMAUo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="u/Gx8aBg";
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0SVPjoU02fufplg6UCU1lm8OR+hTiBw+cX99Xog7iH4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794198415; v=1; x=1794803215;
 b=u/Gx8aBgnHUkuXVi2+BQTYcTDxH8zFUmAR/TVFAy46WVUw8Lm9l8nbKAhmANIRo5EFy9lMew
 uqhCIgOleT3njpCY3/Dv7cMDqi4bwx/iXr8FHzCyP+4xEO4rb2Uae+SFRzrmb+HNtjjXKcUWcSf
 Benz8ZX3QBGriDvnxTFBIbfA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b6a087d0e32380d8;
	Mon, 09 Nov 2026 04:26:54 +0000
X-Mizu-Trace-ID: b6a087d0e32380d8
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: david@kernel.org,
	maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	lance.yang@linux.dev,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	osalvador@suse.de,
	qi.zheng@linux.dev,
	muchun.song@linux.dev,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 2/5] powerpc/mm: drop powerpc vmemmap_can_optimize()
Date: Mon,  9 Nov 2026 12:26:47 +0800
Message-ID: <20261109042647.37323-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261107043122.25650-3-songmuchun@bytedance.com>
References: <20261107043122.25650-3-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B0AA1160003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gri4s3ionuj44e1k6gubmxt9tftir6fo
X-Rspam-User: 
X-HE-Tag: 1794198416-151162
X-HE-Meta: U2FsdGVkX19ZCtoDulqFGJyXJ1ZZvwuL2KI2x88vEMJupGGdWUbGhiLlg2NSxm2A0P1YiI9neqQ95bNn/jNCQ5ybi9AJv7sqbv6oHbbRjyFok7HUTtvByRaBynQlI76jHsP6LTw5uViAmGPwTNr72W2gJm+m51S74uObp2F0d+ldWQPDfobl7t5MuufcyKHM6dJLdx9Cr+kYLGWNk8eBSeNhRdeJfVntqCEBt8vENCDR7hebYwJXquPtAbQVtds+KosUf0dE/y6HJz7G9R8Zudssm/BpAg1Q4f+S8NkpWdfDC+y2CvLN8/SzTqKbcM75kskHR7KziHEWH75+JmAyCOKUfA3H/rp7ELIzrHkaoUyXLL4DrqSFoosGHIb8blkzI9ze+qbzqM3aVqIbwdxalPP49/ChRcKJuCWzogPLKUfvYijFt1Kyennt7k4sJ489Gi2/VbcoejOzdQAgcZopsKxU3mEUuKatj43k8q7eqr7N/vsjaQoHKp1TfIxmQtXMb3KeBTO215lGmMCXgGZksR6sUgp4ttLG3vsv4PYpBpKFhs4xqHWcd0/aOQVRsbU3h5MLzwSSDm1A3k1/Mp/mPoKcEwTqssMSH0fh0s5nx+nfdUZk+R5nnrMrYJkFcnqQE5qkWZy0V0GS62PU+p/HHqRIbkJXXA7UjqN1f0Q2BwwaN98VJOnkaVXsmtjmOrpc/1+Rm6rjcaElW3u6hTbyZrLwi8jHlDq+xBJYjD47TAP+KlxhW52PJ1k68MlUzc5ZmEj0nX34gpLe5RLJmkhA5Wo2xyv7+3V5A7RegSSCs8cli8vbKuRBXJM7zpOSXG+gZ16KVb4Bi3W5pDwySqHeudFAMwDdCzXPPV4ek+RDc0jWP2ni+R1YnnlJ3LIpWzMHB/3rl9E/CPmVmcao0Jz2YjZ5qOWD3wxqT/xNxqpkxG/cc8nyiITDqfUi6pA19HGtGynSl7wV88N0qrMeQCd
 dxUyPSF2
 uJDZk76NgEQhMN4D+UrCwx675M12FNisXFrE6ToN1jGuesHx2OELv5xdmWRbxdVRS99rNkb80ofvQSOFsKqJpSMlfyw4kP12LoCdq/SkkEkGNYzdL+JY0/9ZTbNt2ePWJumSTJn9Na6vMVbLFAn+xGSufs6vL/sDmyp3TQcDqtWYNvlm0yqrMdl6cIQ5VhSv/NwO2tpErBDLXgmRiBNtYQt4mFF4o5EzXrz1utJrNrQLaPk5tXn3CAqjPyeRV99XWDdFHerA2SuGFct2j7AKbDHzgNOWqGVSoCGt5Q67MBCO9e/iH7ow8vxETb2ruwg9uxDsGJixqNWIxaJeraCCUJKlHoEJMbmhBVgMGgwM7kj0rD7/c8v0MdU0ONLZ55IoMb7wu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Nov 07, 2026 at 12:31:19PM +0800, Muchun Song wrote:
>Whether the optimized mapping can be used is now decided in the
>architecture-specific vmemmap_populate() path. When PowerPC has to fall
>back, such as on Hash MMU, it can disable optimization for the populated
>vmemmap range there.
>
>Add section_vmemmap_optimization_disable() to centralize this fallback,
>use it in the Hash MMU path, and drop the radix-specific
>vmemmap_can_optimize() override.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

LGTM, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

