Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259C7FD45F8
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484186B0088; Wed, 25 Feb 2026 17:11:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431A96B0089; Wed, 25 Feb 2026 17:11:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35E956B008A; Wed, 25 Feb 2026 17:11:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 254BB6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:11:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C58BF1A03DD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:11:15 +0000 (UTC)
X-FDA: 84484375710.10.55403CC
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id DD45040010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:11:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="DnStfq/t";
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772057473; a=rsa-sha256;
	cv=none;
	b=6XdbjxKR+8hHiDOzJDgtg9rWjVEt34ZWmjyRN6BiT63Qd+MXwjXT1BEui1QPRVI2Z10QGa
	QhG2FUGuguNAAofUs4NhodAiMjewA37isMRYhYUQEHcEdDvUbl2SlJSyeCd6rH7LEgD34h
	QSPNbvcEBYJj7Ba7TM/gTJFAdj2jc9E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="DnStfq/t";
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772057473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vU6GlShc4/RKkhIbjvbyyJHXZFOxo4/Rb7lB1rnFGYI=;
	b=E8jluA0i2mGstJvJJLJIu4jvlF44nl1hHAL6bURpgnsjGY0wc+iCUemMS81ER6b/aeQJ92
	amHxe9VFpLSTrzU0LlP+4PR2cThLKJe6DqtHySRfzOdQYo4JO9hkdJ/6Q2CcRpeRr2V+vG
	S8zmFonuHTwKvEWBr7VZZs+gmln/Cyg=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d1890f7ee4so75209a34.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772057473; x=1772662273; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vU6GlShc4/RKkhIbjvbyyJHXZFOxo4/Rb7lB1rnFGYI=;
        b=DnStfq/tp8veVAWTEvdehhPZTZwQYLAOLtC3EZy2dWigg5pyGtyOPThuvPGqY57y0F
         DGKf4v6pPRAaRWPbUCCeJ+wOIJGTFUeDnxVptdXrC0flQueVfkzvQZQ4EcXxEXEreaq7
         BSUpfTkRhx+H+hFiYaKW46qxfG8+tRAzKj5lNWTcyYSBeeY9pHX4G7wxNykAMKqTJG1l
         YNFjG9UEvcqsAGoXqxxtfTQDnpsbt1hlZuI2mlGaEn2K9bzpdwtRe9v1qPtfHtjr3QHD
         dqraCBXbeb2oT5qb39WskTvcj7peSyym5VhqlwqtcrUFJHwQ2wECu/BCuAJU9ykQQ14N
         kVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772057473; x=1772662273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vU6GlShc4/RKkhIbjvbyyJHXZFOxo4/Rb7lB1rnFGYI=;
        b=A/RqRlJCE3EuODXNZnWdcRocCMJsosWbTd2w7GW9uo23F449PoPVR7VVKWxpU6qMXR
         ARb8hVEayYU8LRxuSOPtgcGNMwWanEV9sPIinXLb57GDolLxIPKu1pKJiXqoyDFAo+cm
         204q7e2nYGvQoam+kkH115gID9Cfv6QkFmnNqCrxRLxxt6MDoR7hJzuWGwKSDuYjZYGu
         l7QhAN8VwsDIWVAGOkw0RLXYMc5V41RVNGRENQE/cTP7XDpvdV8EnbZ67ZB5qYG8i/2H
         JfQoyYg7T66K/eodoQlHMi/uLz70N2K6sE0e/Q3/y+ufghgWNHhjJ2m1VVIrXpx0+HyU
         PzMg==
X-Forwarded-Encrypted: i=1; AJvYcCU+h3tSneCsH8YHW9iD0Y30NLCJi0NhjqtU9fbRzWXuEwJYE5Fjf5w/ERR0ejcB1/DT0a5kqKKOLg==@kvack.org
X-Gm-Message-State: AOJu0YxUTdVdvkeK1VB7eYKlkeZlFTpHbltW76VLC9/IA6V69sJ3flBl
	M0BZiV30RuYlI9b4DpUazsNIGiA0IaySK3EGWmnwhZN3dkWJsZT8vF8w
X-Gm-Gg: ATEYQzxfnex6MpO8HPlhoGF9tEOvBrOMSWFu3YUIpxkv06rqWZWBA2J2Q6qAMngE+Ec
	rs4tTfW8yy1mpIUTU10k8+i9tJXH/GXTU+hiEBSix5V/ux4lZAjy1Id9xYJSTHvpqOko68+f2A6
	5fDz7YPPuNrTFABFgL9QXOwc2lTnnUPqoYcaO92o4uv0xO8vKpoDyPqEYHM3ovrIzGidSMHZm/p
	50T7HbQSWN14qRYVJBbWH+mfebG+Vtll94Ab86N24N3PAfnRItrdv8SMUgp63sDab+uhpY5d9Kl
	f6nEgQP9TtsoceodukOxMQ6o3YJ+ivN8SGLYpZgzVJBRyoaPoqnVt3nX5hpa+fVDLdp+pWf0ujs
	qqZ7AHbQme4c6QQ17jHxincC7JDRsSv5eSyCy80Bjx7y7PzwKOIEnnXBykj+meoEbyQiqj96RBI
	7MmyJMf7YPyQaGJBAu4gpHXByyNZV2guFUE09r9A==
X-Received: by 2002:a05:6830:1b78:b0:7d5:2c30:9fba with SMTP id 46e09a7af769-7d52c30a246mr8551076a34.24.1772057472770;
        Wed, 25 Feb 2026 14:11:12 -0800 (PST)
Received: from fedora ([2603:8080:10f0:ab80::1382])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d58666f30esm175108a34.26.2026.02.25.14.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:11:12 -0800 (PST)
Date: Wed, 25 Feb 2026 14:11:09 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "ptdesc: remove references to folios from
 __pagetable_ctor() and pagetable_dtor()"
Message-ID: <aZ9zfQU6xeTQyt2T@fedora>
References: <20260225002434.2953895-1-axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225002434.2953895-1-axelrasmussen@google.com>
X-Rspamd-Queue-Id: DD45040010
X-Stat-Signature: xpxmpsqaw8mr5qx1qotjk6qbnxmr8u7k
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772057473-437052
X-HE-Meta: U2FsdGVkX1+JOKP5stLqPffKesV4Q1XW5rG6ZkNwDzPEbK0IUnorJDJba4CktQ/+wm9F7DIofViJixrqce+gIr/kg694BoSghyolDsUGxw+YgHyY/8aAP7/JobL3zhIo+s6jcJyRaIZPMXmg0W9ZC60uND9wYMWS+Ai5iOupkN91VbbhMd0JglyXIlcUvd7aW6xyF3N1O2klJQADByydO9DFySKTC3ppoZi2hVGFnUhBzPW0I8F3nw93ivQ/2rGo0FpjRZYaPxnMmuITP7LKHh9TyCForFYU+O+Q8gCkrQcMNu1f5OY0bPVUvt/kYUNbcbdOxBJenRgkyqBuhAPpQ76e3iG+qCCeH428yv0uyNuhVBoKrWqyCnRYtqCKG9JOrDgq3J5tILb+KhGgpYaljuu3atGXaXiiN3oZuQk4i+YVgx5JVitt+NYqx4rr3Fv83kHsQChBuQzDh36LcIdba/jrGz1gJ/zNnrFdwXfLMXDDDuiXMHI/XlP/Wy6Ao7TH9J4KjREVAMMGF2dBM0Z0QEISttw5x/GuK8TnvifxKJQp5s3OZfRYMSvkmzJHkAhXEGiZwNq/M3lwtv4cVcQuOHYoOF6iScG/qUw6qRU3mgJZ405Ao+MJJipI0rvVHWXXGvs03PVtDYBbVN9UXSQkIcMtRDWs4oy3jBReF65TkjB+b595d6aSP7e//9yEMOLCKUQTQCjnPGlvM6Yx+I7U0TRFeKtagyRVLQkEXUcm4TjcgAh/LM0piYBakGS8iaOOag8zFi0tILAgepk4cFsQbyjTXcABzqACjkPO6Xz2JtTtK+lzNgFVwFa/U6lWo0E/wBlXmbsaf0LDDIOnoMUXK5tAh9hJ5hxVEcllEbc4+Q7+pxt1DsS16yR61o+blhiS7c/jcCG7ml7Zi88ZokbzKj+rsKglrcFxVQJfAB3L69jxgOSqD7tb2BtDmxWCCVij6f1KJ/xIt/TuA3z5Gvx
 gcciUPwn
 fdGE+HPokgcAzuI7lrT5kdnKbt266jt7JnYbqC3BBwBsWEk7Drd3cbHQxq0MVDXbLA9ODyiuuhlJwEc0yhF9f+FXW9wLv1Opwy759J/j7QuczIEtS/+YICuHzEeuUWopYT2XxwrMJjralaq59BHhLAEHP0pNQ1hTY35h54Qyd5uT4RNfoFYk0cfezjZ55Cazp5x4bSjfKxa0LEU5Gbsxve9gyDrt1MbqK1n8FkkDrqWftkju3x18UDUEp2gDLRdekg4imk8G6cdgDqFYSN723+YmFrd/ZKuqLJjm97MJqODJXdKZqdrKj/L6kSdv2GdOtdSxY2L13T6aeG5vTbYVdpp3vSTOdQ7PM3mDUdFXu9S4R9t1zT0xB2RMVOOxv7OrqnZiwUm66VcNBOJk237ctqP/vQQPsFGcZ/zJKBHCuoTklgC9Q5Ui7c/A24izUsT/qAhaGPuy0PXSDA64SHwX7KGj/Ca3agXFakLsMtpJwUyJrx+9DrLtm2Hv0VsddSbGDkVzGxAUEkL7U19bYppEKzl08kJsJ0g36MCZQMCC1tT1loB9t0HwtPQB7dbIj4CS/JW+ShlugopMcCHntKBSk0iFHWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 04:24:34PM -0800, Axel Rasmussen wrote:
> This change swapped out mod_node_page_state for lruvec_stat_add_folio.
> But, these two APIs are not interchangeable: the lruvec version also
> increments memcg stats, in addition to "global" pgdat stats.
> 
> So after this change, the "pagetables" memcg stat in memory.stat always
> yields "0", which is a userspace visible regression.
> 
> I tried to look for a refactor where we add a variant of
> lruvec_stat_mod_folio which takes a pgdat and a memcg instead of a
> folio, to try to adhere to the spirit of the original patch. But at the
> end of the day this just means we have to call
> folio_memcg(ptdesc_folio(ptdesc)) anyway, which doesn't really
> accomplish much.

I recall making sure we had a memcg_data member in ptdesc so that ptdesc
could directly reference it. Until we have a generic version, reverting
this patch should be the right way to go.

> This regression is visible in master as well as 6.18 stable, so CC
> stable too.
> 
> Fixes: f0c92726e89f ("ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

