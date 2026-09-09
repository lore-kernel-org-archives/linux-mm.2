Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C0CC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D7B6B0098; Wed,  9 Sep 2026 10:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F046B0099; Wed,  9 Sep 2026 10:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835596B00A2; Wed,  9 Sep 2026 10:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 597826B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:54:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6E2F1C142E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:54:24 +0000 (UTC)
X-FDA: 85194519648.17.8FBDFFB
Received: from mail-qv2-f7.google.com (mail-qv2-f7.google.com [74.125.230.135])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0EF902000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:54:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mNGBy+0l;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.135 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788965663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GywF7kZkjmE+6xLyiW8/vaQsBEHTERgtyMuo556AVsc=;
	b=8Yx6pk/AtH6YiVi6iHLyWQ8+4VH7HIYreXUDliaw0NC/hxXmCfuoE58lW8qlrulH2fVMYG
	U59TnXNcv5vZ5LCSJtA/dy3FdweTjOAHjwOBy6aa4dq2HDR0/NSMWE33b6DoqrOn+qjbY9
	kSN4gwIMwMsO6X7urvrR608Hs2ybIRI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mNGBy+0l;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.135 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788965663;
	b=ubBkoEiQFoYEGWr8F934yUtbLAsm/0u+/g73LQ7Z1Hcj2LVk7rdDeQ5H2fec9LhSUBcLGz
	V4qlR8b2mOtFrp5eooHYGHh+gnKCjaCNvWx76VKBuVPBMlDEBeiAD5P3Sk1M4arN08kEZn
	p+dwo604NRs2M5V/AIXfUMb2LaMNFVU=
Received: by mail-qv2-f7.google.com with SMTP id 6a1803df08f44-90ccffc2654so35746156d6.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 07:54:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788965662; cv=none;
        d=google.com; s=arc-20260327;
        b=lxQdxNH+tpfm6NBXTE/Hf8E0pZ7TxyncYnG4WmL4Ua/+/CXg8R6VprZt7eaf1DXhEu
         xPt2Ya7ZRn0PUo6Nr4XsHxsa2voM1oxQIocEbmfx0a94br24EZXrvpktAn/N6q3Raa0L
         WkJFnDM4zYXTkCKmtJrpDeWCx/NGY41galfos3lsPSgFm5364XIeoOuJuaAHDgZTDjyB
         zJEZq2tqPVUGik4LlVkDEa/lhMQhUfoAm+Wx237i9JfXetUsgUkqklxO2Y+E+OpBtO5r
         Fh5g3t7CoIvrOUz3AaxEhUp5kxplbr/gehdZ6oaY1ufO3b3/qLcDy1/nKXAbaNr4ZodW
         74uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=GywF7kZkjmE+6xLyiW8/vaQsBEHTERgtyMuo556AVsc=;
        fh=yu9SoH359OG7FbpruISDnSRGuikdfMPdQ2gxUL8uQXA=;
        b=Ux/eAlvr4P3jvcizXJ6DYgiLeZXAjNSkrZKgfdlBKEu+KGb6RwHbi+j73bZrXMMWIH
         Y4/5dWy2GYyd7xyx4az971uqJMKs+GQQ//N9JUIubN6t2SNCocIRd9R6huJZwy32lc4p
         v/WbOWEgzI+ZhgpwbGtHrDdQDCt3sInr5A0Z2a0O+gr12GQLMKTfSOO84j9PaqT6iuDa
         Kh2rl1mvJ3UMFlv3GQ3KD7IeipvoCtxjW10znz63J76KmLbBeHr7US7G/JGkxFkyReWV
         MrPhG2SguVh11jgICzZUo8DhraNjJaScfDJZbQ5eqOny4AVjT66UiGS5agWhhs+WPFSv
         KoCw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788965662; x=1789570462; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GywF7kZkjmE+6xLyiW8/vaQsBEHTERgtyMuo556AVsc=;
        b=mNGBy+0lQd4T4vVd1jpw1A5k1SeNEXm3p+W3BgbgwNnrwM7hRqlaG+qsncBeSIR5Ng
         5ZEn+CRqUCvC7TLQcLFEYR3a6pNT6J5K5aXCOYc40Pijwg2kBwOMatfo/LEDblq2SAcw
         BWWs47oJAv9HkixROve6X/zQ6KlMz6XteBmLI7jpVvkZesKz07x3DrHqLVGt8a9z5n2B
         /hW73ZliGnm9aNLqPuDITksRp2AZzuI6qRJM7FXsXoFZZT4KEpd5qNhxEpXw/Il4O40J
         GFyMU1/BZUFgze5pc2sB4+33WXx7A0DEjKIT4Ish5iNUX8IUAKQdKkqRivuCoa3G5I4f
         Kldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788965662; x=1789570462;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GywF7kZkjmE+6xLyiW8/vaQsBEHTERgtyMuo556AVsc=;
        b=A9VNSxJkykdxxXIZZ4baRpcMfqEGSaMAJbons/3ss3/fTHsQYW6C3JMRuKITpGSsS0
         SOr0C2XxXDfzjF8auJxXj0CSBWISx5NiGcFkEuco6DKfwzxlmMJYFCmxs2xih6QkQZKx
         JnLAg06x5elPKLlWrz9eOmCYv50Bklg/QZHVA607py6+aivw0i2e1fbM+zRMrQzubZKZ
         hUUeIv/c4WXpJhfLFN7mX8J8VIqOtSYzyMC6Wb4WMZp5geBlivJShwd+CdeMLNvWslF6
         kTJp18dAx9kj2e+CTnVHLnJa18vop4N3c67ax5JjmF3iIuB9qpIMgOFJy9RZ9KjkWXVg
         WqRA==
X-Forwarded-Encrypted: i=1; AKwUvByO0SHC2WwT/nvORnUzfh02Frnu1nEVEdzpVTCRXrx4nSIJEFKKjnps+8ciL9pRAgJ7AZxcc+UaSg==@kvack.org
X-Gm-Message-State: AFuF++kGRPTuCJfp7REvpei8LcnBGpdSR27964qzp8tLFEXaCgs0rU3D
	uxVxey2LnVvFa5SFF2cGduvz/j95V/0E+81JJ1HuvhZtFCDJEMHftdOSxUKu/ZITw4kdQyWJhBH
	NJG/UgBhsGXGof+3n3wygDiNrAw1USkU=
X-Gm-Gg: AYBFou0DgfZiEPIc9VyX9whMfO+5TU/gIdA9qhozXz5FhSE3DLrOA/2lkYD95GS5c/0
	xthAF/TMZCXV3rV3tuS0Yh1wV8RFy784Hq52wPqVODix208pf433ytBDL4Cij9M3N7glCmixQT4
	5tWp754gSQVLjY4RQQowJDTTNlsgp7hnL/Y2TdS9oeLabcfXV+MF/rf7NGvWZJBNgZCgVytI9wL
	7HLZLPwTHqL7u6wnBEB/vwJKtdoM8y9tkmgEtSG90tclYnqihPfmYR7fGzjEOuxpJBycdd0l+KQ
	qbbGIX3MIKMc5GQn357+EGWPtj2CmMYFR30YkUyxMi0jrwsVdPY9gg==
X-Received: by 2002:a05:6214:d89:b0:910:4b85:a298 with SMTP id
 6a1803df08f44-9104b85a587mr317423766d6.26.1788965657409; Wed, 09 Sep 2026
 07:54:17 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 07:54:16 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 07:54:16 -0700
MIME-Version: 1.0
From: Tianyi Chen <diannaaav@gmail.com>
Date: Wed, 9 Sep 2026 07:54:16 -0700
X-Gm-Features: AcwNN1Vce22cCGvMoF0rVdpvGrE34HTDoYBSso_WyrA4nxslSygww_YsIT4lk9k
Message-ID: <CACGbirSdR30=YTPQGN-=202jZqiF8gBSewhq+K_fTSNpq=DMhQ@mail.gmail.com>
Subject: [PATCH v3 RESEND 0/2] selftests/mm: Validate selections and scope
 memfd_secret setup
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Joel Savitz <jsavitz@redhat.com>, 
	Tianyi Chen <diannaaav@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: qdj8mfk81n5gmqo1arhj9emjnarddk9w
X-Rspamd-Queue-Id: 0EF902000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1788965662-37533
X-HE-Meta: U2FsdGVkX1+5Je3WhA6GPYphoZRh5TLE20FaUQV8i19l9uxZetrKASBpEVz160OYciPWRI7wi/bKzUPDHaNJ5vpdp/7pfCNQJk4azzvJyejlo9oMsnDLllHWDoXDAxx97E5BJ9BQIFMVmbmsmvu9+iQap7C7LIU28qvmXtmqso7PR7Zu+vk+d29eSZ5y2n9pqtyZsfjh/kB9MKiqPb2TLZhA3jpMOexay9eZfe+M6KHThZ0VA64+nH3JlvbnrDDFR1VRScaZneiZYur/Uy/hyGThhOji9IqTlDLAGNb+MuCsPZo2TUL7Yx18E8pk3C+U+iyeiXaBKQoa1gqRgly+Jym8Yv4MvE56M2K4KJ/NsLqYHi+YyyTHF/kX+TgVCyzlHF6eum+KDQF7fOnNNtowAQTa0aZbWfwUu/qmAoqhtaXhcErHGLf5uWPYCNMMuUkYRepEdfTodZBRs6ce5hfE7RppB4vkKq2ZRVbi3enYPw/f0Q4CeKdUjbwSsBV93hwA8NhZIVoA99eMK0mLNz5hWCqythJvYrtuFNoSJ0Hkz27zy/ExmEUO5CN4pVFEVbCVslejFbU6YY5VZEWV/8G7stpafrRbfbbCifG6isfnwdM32b4ySyhD8qeXIxB53rRkM9JAgji30j5lfBUeDYM7qWqSYs9QpetNysgMvWA0xvUvX283NZyt8keb+qVhUmFMa8GJN7sJXMefi16Mpip9N3i/AKjKMtAqHNZKkq1Kfk1qMu1XS+BvrlpV0NHFhly8lvWGIZrgr171X02DSfllDKN4WHFYfpHdaqoywIAtFtkPVkdrJST4tMlE0hzFFStk7wLue96Koc/6u3eCrSa6vPJ5FsLmWDCnlBv1X7aCysLrZUgWKYSW3YoI7ns9YGEh+qHYxJl02NTCSYMNHJ+XNnIoYGfIQjCWYKOO2NfHiJomKJBcqplHEVrBSGnSGTxmchqXlCoOLSW5rG23vqg
 5ot+vShf
 JKd+23y+2fvFg+XUpPcCl8eZxMpH527VcpW8oqrMd7ak3J0dS4MQpnbIFlDJRB7ivHE1ZEELrFZyRIfWWqf/5iebbH0kAoWOM93xP41blPxK9KowMAJqF4StL4a5fEkmoxza0RDCDqzw9gb7lFHG2wripVtb6jCljflmo+2Z76NT8rQlI0VVh+Vd81TUsoiix024skyrEXBDOTzVmmJLRop+ZXE7IAlHnOeO/5sEl1aLZcs/EEZjxB9cXik1n+GXxL356NPpVs0O2XnuYQgxSk+maEQepIx5+HWELYJuCAYT5ZQ2e4GIue8b/MJK2KcVoC2VPLkbyRB8g5BY6899J433zLPxaLgPs0/xQ7Ex/6F6+bn7af+//WnIwMGqpkIw3kXzTa2pmIAFxZgFvIJ8nfci+VmFjePJCoGghdHeeJgFrjPSupmYWwBXpMRw/IVlbv94GlJ3/sBKN2qfCN+CrQU/OHo+L6VWyVL8Fhm8wgPjRgf5/lPeMEyb8vSgAmuIbl4dhw5AX1ERbn3OXuAbD7DZDJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_vmtests.sh can reach test setup after invalid options or category
selections. Its memfd_secret preparation can also change ptrace_scope
when that category was not selected.

Patch 1 rejects invalid selections before setup, using the category list
in usage(). Patch 2 gates memfd_secret preparation on category selection
and executable presence.

I am resending from my Gmail address after delivery problems with my
previous address. I could not confirm delivery of the earlier v3 posting.
This series is rebased onto current mm-unstable; both patches are unchanged
from v3 according to range-diff. Neither fix is present in current
mm-unstable, mm-stable or mainline.

Changes in v3:
- Initialize VM_SELFTEST_ITEMS to "default" before getopts, as David
  suggested. Only -t changes the selection.
- Use Assisted-by: LLM in both patches.
- Add David's Acked-by to patch 2, whose code is unchanged from v2.

Validation after rebasing:
- Bash syntax, whitespace and checkpatch checks passed.
- Ten invalid option/category invocations and help passed before setup.
- Rebuilt the four focused test binaries and ran the rebased script in an
  x86-64 KVM guest. mmap, memfd_secret, combined selections, tab/newline
  separators and repeated -t with the final selection taking effect all
  passed.
- The guest lacks Yama. The ptrace_scope write condition was checked with
  a disposable file at the expected path, not Yama policy enforcement.

This is focused validation, not a run of the complete MM selftest suite.

v2: https://lore.kernel.org/r/178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc

Tianyi Chen (2):
  selftests/mm: Reject invalid test selections before running tests
  selftests/mm: Only prepare ptrace_scope when memfd_secret is selected

