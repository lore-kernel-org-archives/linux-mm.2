Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69732606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 04:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=OiQhjtp2
Received: by kanga.kvack.org (Postfix)
	id 7470D6B05B2; Mon, 16 Nov 2026 23:50:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71EF86B05B3; Mon, 16 Nov 2026 23:50:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6349F6B05B4; Mon, 16 Nov 2026 23:50:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 410236B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:50:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4BE8C01CA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:50:40 +0000 (UTC)
X-FDA: 85443385440.16.36DAF33
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id BF8901A0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:50:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=OiQhjtp2;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.43 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794891038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bqqmMB4+kyoRGHHPejEHuADL6UxgHY0xArC5J1XYUg=;
	b=nnRvUM0KG1oXY3cMedUJQcZDyXq5M2k1HmsnKWPtb8MXmEuKNPEWW3y5h02S4Tr9V+YqIi
	5X/qyfAgoiZr2D3GgFRwta3yqTTwxiDaR7E+CQdgiIic86h/Lq7uEV5fu8+6sRtprxCuhi
	KDDFYY4kXrBZNyU1NA3iSOnpFX9gY58=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=OiQhjtp2;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.43 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794891038;
	b=WajY7wXsQ4O/Ru3nL+OW0BIty9bXu1a12LXUQyLSTMa8dp4XmkgTOp9i33WmGOWVAejGgd
	Bt05k0ckqPeXvXSGHNZepiJaiNBfxKT0nlNj740VrSOIu4c15+D6ZM2MTxjY+aIKT74jOx
	5gzPS270jQUqIdC5gRWOWIIa6KEO9VA=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1b3b4944a0eso2172106c88.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794891037; x=1795495837; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9bqqmMB4+kyoRGHHPejEHuADL6UxgHY0xArC5J1XYUg=;
        b=OiQhjtp2taZ6Yjd8dmt2qJCsFpw1KgxLH3PuPuwEnCArvfOZA+TReb/vBug1JZq26R
         N8zAtOQwava6VZU108bZdzCt2JSgEDdSY92OMXFcXVHEG6eGjRI3iMzhDGvJqRNFWF1p
         LBC3/tvC2AVuaG4upowh40eMP2ayRVY6RFYZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794891037; x=1795495837;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9bqqmMB4+kyoRGHHPejEHuADL6UxgHY0xArC5J1XYUg=;
        b=jY/0prdCGIdo5YJaQ+5h0Kvxe6ltO98NNxW4XjftzMsP1NnEXdI/PbrXueVzLoHmU6
         Y37vl8tlpy9H5FnBol1yH5zD79oaC2ObwtRhrr52yvOtckwEO+wfj9fIB954pUpr4tL/
         kslzUr2oXwwr3fDZU6qiqTQLuck2D7JWtbqDXO0qIC36Efn1zx0yPiCt1NqEsXjiu0X8
         6gqT3+iKW9kTmsXDIMHy394VeIHcS2nThzYjDZLSVQppemgkMbmtPjG3OnIn+V/g8QYF
         MgyGwKRAw/7Z4Xwxflc3pIs1vZtMbuD63qSAeh+v3t87FNZhAUVYVFwgpITuEbLyGy6m
         IeBg==
X-Forwarded-Encrypted: i=1; AL+hErFLtmp+hE4w1m3DIoL2hetTswrk8ztvKUUUm6vjltYZMZM9c0DfpKwm+wx431bZ6TxTaQcZUTtmyQ==@kvack.org
X-Gm-Message-State: APuU4Z8Pv4GpYloBBT0H0x5aojaX+9xBUd4yXANbCqYrC094i5AFZGdN
	wdhxzQpBAe+MtW9uF0A+BVU8yEj6FUBqTk3CFc9hiKsYg0UHwZgexkHS0sfMzR1V5N4=
X-Gm-Gg: AYBFou2eH3MJS8RvP4oipn5SaoIs1TMbC1w/tmUnOn0KyUve7zTYZT2y1zEGezNYG7k
	rZ8DUkGC6TJ9c+cFKTwmZWvzXLtAaBfdAj9liWeApmtvblJQo73Y5Pqglp59lYUivxsYOerhoVB
	kRqjV9rzG7NifD9/zlii0NH2DykBHTbxQD4iSdtCniuWgp6i8yPy5vhioUSQvWxbodjy+m9IQWy
	WZyLo+8eR7Ow7JGp/ZDaEIvrwKVeEtCTRsU0ijHF1w+3LKaYMuHjbv0JqBRRUkBJXTioXPDAPnM
	lqSgGMPE90HEzkTS6foeQghEYO9tk00kseoXOoaLPiJ08R8jFe9fVvNnpdOqsnFiCLV7YIlJIf3
	dGidVQB9lgLLtQL8zYrNamce7I75u9XNgnUf2bTA93vzhWVi0v23F0CkPJtIxaL/MPg9zHUpKp+
	SfZsNIuVYNUOQpma563a4g8vYir/xKAgx0A3UMWSWdvQu7dh19bDcvrKxxsW2HLu1HpIWeVmQXt
	OBo3FvOXviazD2VH9WWtLr1ctb8ky/vI+HutXZNXLfcu/ldFXZqn2jeo4YUt71Pv4SUyi4QriP6
	zr8M892IRrjdTnfkI/V3h8A3i+G0yrcvltO9v8NE20ydmgXzjDOZ0bkRYP4kcGrhADUYNZJLqTW
	F+mWiBS5CMwoVZp2dNUQEsgkCDwYghaFakDA3xX907MMi1pGNVB33yP3oJ6EF7q93Nl/o296wi6
	IAZuL1G3zPPd9wpvci+uOtjyADes8wtjBtR7OJpQ56TCDoJqeb8KnnITyasRXwMajg
X-Received: by 2002:a05:7022:96:b0:1a8:4997:65f6 with SMTP id a92af1059eb24-1b503105175mr11734678c88.20.1794891037361;
        Mon, 16 Nov 2026 20:50:37 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm53517692c88.9.2026.11.16.20.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 20:50:36 -0800 (PST)
Date: Mon, 16 Nov 2026 20:50:33 -0800
From: Chris Down <chris@chrisdown.name>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: linmiaohe@huawei.com, muchun.song@linux.dev, nao.horiguchi@gmail.com,
	william.roche@oracle.com, ljs@kernel.org, vbabka@kernel.org,
	tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org,
	akpm@linux-foundation.org, osalvador@suse.de, rientjes@google.com,
	duenwen@google.com, jthoughton@google.com, jgg@nvidia.com, ankita@nvidia.com,
	peterx@redhat.com, sidhartha.kumar@oracle.com, ziy@nvidia.com,
	skhan@linuxfoundation.org, corbet@lwn.net, david@kernel.org,
	dave.hansen@linux.intel.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 2/3] selftests/mm: test userspace MFR for HugeTLB
	hugepage
In-Reply-To: <20261115160105.2507650-3-jiaqiyan@google.com>
References: <20261115160105.2507650-1-jiaqiyan@google.com>
	<20261115160105.2507650-3-jiaqiyan@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avvdGec7NCt5oAFr@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BF8901A0003
X-Stat-Signature: 96z7ss8bs9e74maz9xqfcwrqkwyksr6h
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794891038-883893
X-HE-Meta: U2FsdGVkX18SaOOoMqUjPPcq9dRgP0d2Hr1bVEmKlOhdl/2Ev/8XFhlB9yT8MC4KXV3NhiSF+9XVH/7o1B6wZ8Pjf2I6ftfqy1nM1weWJ5+ADLTwIMF0JxChVW2X05IhZ2oDOukZBcUXIeULc4kUMIQS2YFDU1+JSYj3fRdmuYqvFf8+nN9zTSze3FMtozxoRDhc/fHOM6dHmTKSepKU6UnMNR8m34ccc0bZhplnUaqgh4voD34vSHPs1Fi3axfC2lC8zgWvRdwjcLl9maUY5QqxyCwSMPZbsv+qZYKWR72QGYFurGsaPyDEu89FMxtaXlTOr1xcYk/csYitnjXQ3x+b/PrfGdm7koS2uBAMHtY1VZ6KXktYzMb/nU9EGzukA7oZmulLDa/4mjgIn8mKGk6Kul4ftchpxkicprAERbcBFqDpOO2oqwbdN1o0Xl00k4zpduMNJwEUOmejXF7Y4iqz+mHi77cDZCf9WSMs7n3ZkwSVLzjgDSUoSIOD6X+cojsaxMkiEZFZQuiZzwqXFUpqP5ZQVxH2UjbP+Gng1O6oJjYt6YKuQHqY9ZJ4ed8GxJNlhEJkfZJ9JVdRCSdJjnGoFUEG35is5ajHQs38ZSpAslveX3O/0E60MfMNcRYVMA2qQmOqG6XVQJQI8/H6fqCSoh6L5FUNnyj3gO5yOFbYCsDRgQv96UOzDVI7wlJy2t+cGAXhwfzbMVkhCOHX/5MZYX31zRxo+PYqAThXne3FmzoBMaYnPfnZA4TjapAeO2sq1vw/ml/8+vrk54WBxngv3IryvCubc/r3y5NSqklMPwJbcGIlha+4VDR8HkWuIt99jdy5XanoxL0rzkjtNR00FAmaN5Ap5A0ZosI6gVa6VXL6+TL6eKt2nQVl8bzN/yXsSnsWJgjmh3nIqxpY0R3Z6z6BZnV0UVWfKPNaV3ykzvsukm7F2p80H3+ecbKWZ72H8QhZKTWlxaBPYIY
 toQ33nEA
 jqN9mm6NTj7rLIjF8SCeZBw+kthj5Gs7i9LOBn8qo+uQC0gtUNxScoLG9ZgbGiPnzG6KmNF/itxRNfU8h5IFfaw2WTqce/OMFHhwJH3geQsKFX3Z9ThQU96Xy1Cw2wj2BdXcZBzFT4laVEApKzdXa9N2mBJ5i1gjvnEnoWARRlaN/29JXID9Y/ioE7iD+7bZnInri/LXNTE2VtZVCFo1HRAPYrb4s8+abXd5/QZO17RaTqkZRi12HWSTrPoul92TuiA/ulprhvgG+sagduzpsX66TEL7RC/3diKxuEepVatmacOwQT1S5poToOnU2czmlJ72Ed22QUL3hTZ2AOxUAA9PA/th6t4jKEGfWbn3MvNzVcTlmwG45MNvcI0ublW4menBCIqjFMupq/rVR2/k+h6gxlIISPBHBu1HHgchmEBzCQyxDaylruh03MfZmUzgtDoARx8pgOIdOSGK6LxUuoKM4rHbjTbfSd6Yr1h0HZzfSlzmrslu9DQsUKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jiaqi,

Jiaqi Yan writes:
>+	map = mmap(NULL, len, PROT_READ, MAP_PRIVATE, fd, 0);

This isn't right -- a private mapping reserves hugepages of its own, but the
4 hugepages that setup_hugetlb_pages() asked for are all in the page cache
by now, so the seal mode fails with ENOMEM when the test sets up the pool by
itself. I think we either need MAP_NORESERVE here, or to ask for twice
NR_HUGEPAGES in seal mode.

>+CATEGORY="memory-failure" run_test ./hugetlb-mfr

Probably worth adding a 2M line or two as well, since this only runs the 1G
case, which is skipped when 4 free 1G hugepages can't be allocated.

Thanks!

Chris

