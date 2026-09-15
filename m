Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E461EC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D62666B0088; Tue, 15 Sep 2026 06:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEC1A6B0093; Tue, 15 Sep 2026 06:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9FC6B0095; Tue, 15 Sep 2026 06:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 943666B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:46:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD59A803A5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:46:06 +0000 (UTC)
X-FDA: 85215666732.20.3E205CA
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf30.hostedemail.com (Postfix) with ESMTP id F098B8000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:46:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="L 6Rc9ri";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=prKVy886;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789469165;
	b=IkYOXwzPvhGZoe+gqFJk0aIGSVXqTMxygIXZHYoMtOB1bhig+WwwoSU+93wTTHEutcpsww
	wyWkb32pb0Czh7S78Khz5n7BurP5pdOf9oxitK+pyvz07ns4rbIUqFjuDxnz86Bmv9KSJG
	zUm2M2JPq2gHEWtLep2NDQP1ZtY1m/g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="L 6Rc9ri";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=prKVy886;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789469165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3KZSIAXGNgRgXQOPp8px8yy9kwrf84Q26i0MJdE59o=;
	b=1KgJtshGpfktbczFyNEucUNn9b4H0fP3LPVrwf9c/kiMG+kIm9ar2T3vNQMYfEwZ77HkrK
	zfURQLMS/WSVWxTV+PXgoQNDh3OqlE96YdZ5g44UdHFoIQ7BH0hvXaFZ+LqO39VSzE0SlF
	NcBc2KEB3XGVgkyodz1crYld68kx+Wg=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id E145B130051A;
	Tue, 15 Sep 2026 06:46:02 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 15 Sep 2026 06:46:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789469162; x=
	1789476362; bh=r3KZSIAXGNgRgXQOPp8px8yy9kwrf84Q26i0MJdE59o=; b=L
	6Rc9ri6gxOuiD4wi+F4wef0a+UJG3EiKJgnLWTLHVEuP2+3wj7T8IKZ0B6yDEWWG
	Rm4ZRGyt51MckaWR05Hr0T7xAGvJE1ALKaZd1VUKZgJokVcvrRTR7mUWsWRqXK2E
	9+hdo5R2yNg8kExFfkOQ17IGg3Jw+kuhOZtz9N0fC4Eh9Oga3O5w95DDEze/K3T6
	I1nJLl8V6uAVt03r/Z3CSUr0gayS/pNXiEHpjJi7+CgQAKIy1lxlU/jT3MRV0cNP
	OKVwiEHLiK2BmanG+W8XUrQo47YFtv5+v7VrZqADMQfaMmTJ/QQaXjb2SyeSVIbR
	UfCmgsW2N7P4jiCYK7yGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789469162; x=1789476362; bh=r3KZSIAXGNgRgXQOPp8px8yy9kwrf84Q26i
	0MJdE59o=; b=prKVy886uXsn6neUNmcdJmKXoR9+2Oz849wVpc5xfxikecwlI1v
	OzTaFGnwulqZJsN3UMQ5VPHGPOcKz8ao3fvIBIxcZwacIJyFJHFvtfUhyLFjjY0S
	tu/wZ0EKacJ2aleR1w+W16vNGjBiWW59PmESpJWe4sqC1c8sUAVCAkdllibLM1Gt
	JACF7lYog81yldUY55iIK0dJDUioDZofFF+gf5+JoQi70DEeKNg/AYfMbm/MxE5K
	yfSlV6GWZP3WU7W0ZC3I3QvwgzUjTRBjPVk/pLkMd4ArdYD4nr/XcWFFrogWI0sD
	vb5KsMOM84YDaUtr2pJGLL6zjS0BSZW5N9A==
X-ME-Sender: <xms:6SGpavVCAue0eV8cvmHt1ZCUzT6awTHI5y_G8H-cjxPLULy7t9yadg>
    <xme:6SGpap42XUC_IC4BjACzT-tlborJZP-U77tyl_4xpZchdpZVxMrkC9r0Y87lws1Zw
    A94vbuVjfertnWE1tp1382I-eUaB7y6HY67AxPpzUg05ab4kQofEtef>
X-ME-Received: <xmr:6SGpaqJcFbEvAl65vM5X_uwTe1dEIaQDTcugMUgG0htPpEOgLEEUHRxiSqE>
X-ME-Proxy-Cause: dmFkZTFDaruGlOr6fTdt0YZFnkPzwcHHkwV4lV9ndG6J2fASDcnXeHcQHuo3f91XsUJ2pA
    HU/uv77nPp1rP5u/CbuPdLN/p1jpq3LVrMj2+B0r4SYZ7ziJEAJcJenoZ8R0wqbx6uZdgx
    iwTu6LwFZHMvs/xqnUg2729mQ1gnrMulHt85qf2gQIHouioHBhh4T8jxnHZTj4Ry1kp9wz
    upUTCMcgIk4OAkHdMZTxTifA04sMoR4eTQ43U9O+yMhwCEBYBv0BpxD4y1bzDxD6miaZ+0
    f1p8SRDckwuQcEfweit5QYJe3BE3SEy4P90VboaSv38MUixnvuoBh8IePTHqg6uI6uPwSQ
    9TnlZDd3WFxpHdKywm9yfMnU/s7dF/B8Dv/U6Mr+3+8NScUaikLRHSGmTXPt+/oh6dqnmk
    6e/qjUYVd0japbWkdvtZpESil5JyXy91rl5ZhL0+cWwfCfNqOkCDdT+5qnXiTucG0iuVtF
    EkDTimZuGUuiqYGPAyIrjcyUXuso9C/YJp1sDYYIcDspQyRxdqx/HHBc9WMlpIkxe8qydI
    9ecVBuO3NoCqT3ImcHztcP3MfpOaGOm+I7hu0xyohn5YiEyq6gVd6BnqgUe27onY+gXnNB
    35uBC2q/EENiA+1aXvvah/BYgPogoJCqQsxuAbiN8clRuqmZKm1nn8TiWeww
X-ME-Proxy: <xmx:6SGpakhpOYKJaTFw4kZPYqtjdtCwcfNdN7HVop_yjwrlEWB-d4LxcA>
    <xmx:6SGpasK-800YAOZRVu7WXruEk_79vLmMCl6tQEVAZtTR6UUIhZoX_Q>
    <xmx:6SGpahGXgD-PlfvDBrMuI_H4LSSUXL-bLvomY3yUdXoMhyBTszbf-A>
    <xmx:6SGpak2rKS216hDIjSz-nBdsOO-FC6wZhkrn9oTdK17KmMZ7K01OgA>
    <xmx:6iGpasX0no-uhE96hzvYa67Wne1yGJN4-TV6_rq8-nnEI3DQG57hLGFw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Sep 2026 06:46:00 -0400 (EDT)
Date: Tue, 15 Sep 2026 11:46:00 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jannh@google.com, willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, 
	mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aqkg_iU46BJghUNk@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <9f51ac27-24b2-495b-b397-84865f977d24@kernel.org>
 <aoXRi3ngBhO54Akk@thinkstation>
 <fd179a26-fd69-4b5f-9af1-b3755ba9030a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd179a26-fd69-4b5f-9af1-b3755ba9030a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F098B8000B
X-Stat-Signature: 3jndt7yzcw8phtd8w195rwbozdgu9hy4
X-HE-Tag: 1789469164-326446
X-HE-Meta: U2FsdGVkX1+fC3sJksPdwfJDA2fLWHQhHhoEfa0KnZKKHIQMbzcK32TW4KEVdMI4ZXD3J/T8nz7oLXDuHeo7Hd4YPI2WGj5hRYv3x/vOk2I8JZ9jwVFtjzsMzSA7S5KFxfTsilnWuFfGbDIIg6zuGKE2LiY1xu2pC7TaOoPqd5DFwq6yuXjGq6JdGxpzEUDYp7ELslpIOtttBhjgxQaLWDnBdH4AAg87jffjm6xmbVhMaXjqz9BORXbSWemvDOSziF7Ct+VJx4tsvEqDngsMOpv8IyAk6n/sJXUyJ91AtHtsiUJLhh4DvWADSCvVW8xhA0ycM2QKFTcHzM+boPaE7BNfELR1H/wnjrCRRyYK8GV9kqO7LwIxefQ0lVi9RUppZmeJnjP61upHK78qtGncYvmtC5ZTKGyoZ6zhvk2G4mX66dNxRXM5KeVisnlnZivkzgkou7rfsJJ0sQ1I+6mRthzRcOyKik/WNBLUHaKvRH6ss2SlXgLfDXE27qL9BXP1hY6EQuxVjYpkV0TceiiCSSdLKGQ381W3ITgGBVPMH8OsEklni7VI+wMj1JwKYN9c7qn8dFIEJ22xt4pHiu8pqnmSfQAdEGro75EtduWdPSUiFnVa8IGpMNZ0ncN1YMS64WH325w3+ASIL7DOd9hDs3oDTQlI00UdKVLFBTkWBYhUIUPOgUB8fqqwuBngfI25RPpdfR+Vtf0VbtYGmHRMt0+YC87EqP/OdF8WYp5bZ28aR7jLC1i8UR/ktUT6aWzufRdx5NHN8h0wkLNtcRsx6csNWCC9n4uI7CM4OdMp0MOVw9SXdUSpNFanyWJhFeSVOHhPBszDM6+M15EcR54kWEj2cjHD+rbTuha+OKBmbFqvCz+C0FXy/SrpALff/uHuHmhIvxOr12bbH04zLim1y1eGZEV9QTRQFq6F2WMo6a5931t7Mq1XRMGwvxtn6QPIf6SlDXGeHC2G1peuP3I
 wFLQc6RR
 Gv7wi2sTnCmVUXDglkN+8JlcxmIg/3dxfMsAXSisezt26sizB5jX+pc63qWOBrROyWOt26MSrbyzIvWstCq1JXxu0R5qVO2SlcOB4BAvJ527Ze4TJWveVlcmO7CmZYHdTF0ry3kxHnMAvMdrr4e9s8/jsubDsPva2KIpVz5lMUtVg7narhAG7sZCKa/JLWdHg8ooIVCWIoirXa8klXaR+qEaWqjzuIoTW+orOh/oiQeFR8Oj8S8RrqeWIvfEHLraWZF3cM7oOpa2/qfYIGsOIN8Okhf99dNEa1U77wCsw3ZCX3w5V24ii+auu//HYkpZ4Kg6juGW8NHpGboJAvQgAnPLieZdPJtClWATQtK5/O5JhoXjkNJJ1NyLV4M+15DUFEj9JD4nE4a3mUFZX5MiFvsTb39s7mhrhfbKp1+8uEe/eotcjET/6o2Z3b5i6sAC/hhRmPZ+DSedab7R6b0Sl91+hQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 05:07:37PM +0200, David Hildenbrand (Arm) wrote:
> > As I mentioned above, we drop the ptl after the freeze. And take it a
> > second time for the install.  Allocation and the copy run in between with
> > no lock held -- on 64K the copy at PMD order is 512M of it, which is why
> > it cannot sit under either lock.
> 
> Hold on, are freezing all folios to collapse? That cannot possibly work with
> COW-shared folios that are mapped into other address spaces.

I break COW for worthy candidates in the faultin prepass before freeze,
alongside swapin. It simplifies the picture substantially. No rmap mess.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

