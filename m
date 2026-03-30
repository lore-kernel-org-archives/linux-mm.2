Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2253CFB3CE5
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 09:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651FE6B0092; Mon, 30 Mar 2026 05:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A196B0095; Mon, 30 Mar 2026 05:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2FC6B0096; Mon, 30 Mar 2026 05:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B84E6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:25:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D11D5160619
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:25:04 +0000 (UTC)
X-FDA: 84602195328.01.B63B7A2
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf01.hostedemail.com (Postfix) with ESMTP id D008540003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:25:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774862703; a=rsa-sha256;
	cv=none;
	b=1vAwwtSjJSvcN6/whP63nooT28g4QJ56N06mFDWhURMg2LRH76V9V9z8YN7JKfR/sdDYPD
	9DMZI+IDmY1yJoirsnPOmwK3IY02YNJCL4XJArmzK8pmnTT9FZ/L+xSiEUBl+rL9UZ+0Wb
	E27nc47WWKxVr7dGTucdWXA60a1r7HE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774862703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GsaNZleofBMRvQGbqW11fbOA1pZQ++5ROcYE/Rq+0Ec=;
	b=ylD50w6Sv7SRAb7mJMvC3VSRfZQQb/YlbkT4hvZKceFby1Ae4WmYziLbFmksf4M8SbI7x/
	IH25HuvrPRakTGQW53kHzaJcVp5In8INQr0KAfXNqp+iONk3gAJW6wRak7TShtgvQTVNJB
	HBBlmIGt4voC34tipSi4rutHxf0QKUw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-b2-69ca41693796
From: Rakie Kim <rakie.kim@sk.com>
To: Gregory Price <gourry@gourry.net>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	harry.yoo@oracle.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Keith Busch <kbusch@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce socket-aware weighted interleave
Date: Mon, 30 Mar 2026 18:24:51 +0900
Message-ID: <20260330092455.411-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <acXjVmTLSi75elvo@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsXC9ZZnoW6W46lMg5XTGC3mrF/DZnH38QU2
	i103QiymT73AaHHiZiObxeqbaxgtnm/9xWjx8+5xdov7y56xWOx/+pzFYtXCa2wWx7fOY7eY
	dOgao8X2hgfsFudnnWKxuLxrDpvFvTX/WS1OzlrJYvGtT9rifp+DxZH125ksJl9awGYxu7GP
	0eLWhGNMFqvXZFjMPnqP3UHKY+esu+weCzaVenS3XWb3aDnyltVj8Z6XTB6bVnWyeWz6NInd
	48SM3yweOx9aevQ2v2Pz+Pj0FovH1Nn1Huu3XGXxOLPgCLvH501yAfxRXDYpqTmZZalF+nYJ
	XBmvH61jLvi7i6ni2sz97A2Ms68ydjFyckgImEi0d99hg7F3zToMFOfgYBNQkji2NwbEFBFQ
	lWi74g5SwSzQzSax5YE5iC0skCExYfl/ZhCbBahkz84r7CA2r4CxxPK7R5ggJmpKrNt4iwXE
	5hQwk3i2cjlYXEiAR+LVhv2MEPWCEidnPmGBmC8v0bx1NjNE7192icaNnBC2pMTBFTdYJjDy
	z0LSMgtJywJGplWMQpl5ZbmJmTkmehmVeZkVesn5uZsYgRG8rPZP9A7GTxeCDzEKcDAq8fAa
	sJ3MFGJNLCuuzD3EKMHBrCTC2z39WKYQb0piZVVqUX58UWlOavEhRmkOFiVxXqNv5SlCAumJ
	JanZqakFqUUwWSYOTqkGxlKv1caLmcuaIxdes0suvZxgJayvOD3A+buOouiuP4GbdSZ38ex6
	qV9hGj/52vYpQUVFJiKnJEtSK+rKKz+JfA9oP96u9vv0Cv5Cltu1F97fX7Wp/czS0Pk+zYf0
	iv4+3nrKvdbysn0JQ3uC97f5DAumtbr1NFTnVinY+bT99/MvUbywlWeHEktxRqKhFnNRcSIA
	YKVMOdwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYQCG/bazc87EwXENOmhgDUTs4oUsvyDKEPND+hElhCLkylM7uE3Z
	VLSSJpZUkk1zqJvJQtDU5Q3NpjNpzunE0rysVKZmqdkw00IwM3NJ4L+H9314/7wkV9iD+ZCs
	Io1RKiQyMe6JeZYGJBxhz/SzIYvaYFjeYMSh89MQDts/xMK3xXoclmiHAOwbz8Fh3bgRwIXW
	XwCuO3sJOF01j8Ef8y4u7JpbwGDtUwcOe1srCFhkcQDY/cTOg23qGQIO6voxONJejsMp4xYP
	2nU1GFwr8IXTBRHQ4ljgQWtDGwc+HjbgUJ9TAOCExsaBdUYp3HjxbDvqmSIi/JBJ5ySQoTkd
	5eeNEOiOdYmHKs2LHNRcex9HzatFBOor3cCQ6eMJ9DD3G45W5iYwtDaJUOWX7xyk1d9GDS1j
	GBowWInz3vGeJ5MYGZvBKINPJXpKXbP13NTNdk6mo6yLUAP9GHgA+CRNhdHtuu5tJkmcEtO2
	zgQ3iih/Om802m1wqXycbpkJd/MeSkprqre4bsa2FbNplHCzgDpKVzutnJ3FQLq+aQJzM586
	Ts/XVP/LhZQX/bWxC+z43rS97DO2s+9H57bquRrgpdtV6XZVBsCpBSJWkSGXsLJjQapkaZaC
	zQy6miJvBtvnVmX/LnwJfo5EWwBFArGXIAS3s0KeJEOVJbcAmuSKRYL8EhsrFCRJsm4wypTL
	ynQZo7IAXxIT7xXEXGIShdR1SRqTzDCpjPJ/yyH5PmrwLsZqH3ik6MkJk0aaXR2BLZN9pRXa
	lT91sTXWzY6lxlz+mjq9O/zKclSk6bUHOWk+F1dokKrW3+/PdrWZh5+zZ+tmkw6fvugKdbwa
	Kz50Ly6StEmexS2/EcnlAaslUaLBgbs+YuM1g81/3WPFj2q6pbmQH3JgnzboZm4n2xMvxlRS
	SehBrlIl+QsPriAc2AIAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D008540003
X-Stat-Signature: 4syfcwyynnrks3g91xwze316z7ycwnem
X-HE-Tag: 1774862701-177007
X-HE-Meta: U2FsdGVkX18lCdZUECHnxTyc7tLK7TYuhe1QjNtkH+Ly8XjveiIy0v+Xe4P1BTAUoKIxHYp8sWXvfC6XMk6mgQjDoJIvERm7IgH1NEPkkijM4Uo6mPIHaiN0ByzFwMMca1CRUZ+Wpx2O1EeDiQavCOvABKyIEtJfwlEZ4pc2u6BBUtLCbBp6aLvvcSXfXSmLFENXPTpTVLL4/RtIBEEewwBeQsgKGi2icehloF1pRm3V93S99BZT+OJweg8eAxIdUYCDgBT5kPIi2lKMjL1CNSTbVHSh3yI36WLwkBjbNUmDne0uFvsaVRdto820cRZVGg9r4peGCSuo9wlONy0OSCNEyWqrj8PHNUu492JUvQ2mG3leNzXkGx95k0T5kZJXGZWmUIYfJ6+Q0/Qsp14a929rdvko/fjFNdVVlTAABpCIKDd3PGSkDEeR/QjiaWHM2JUuSOMsXzzlnuwUSqXAXKK3XH39BRKQljxmkFZ3FCa3xdu76zj6w2uZ9IH4kmD05apUey3P986yoHJpm7haWzitOGsxJxtE3Z6f1GI77O2rNT8zBmW4Ezc7c1+LpO/fwzZ1BU4G7gyXBXLmeVfDHEoqC2+M/YdYgc/en3VH9s1EPPaZsT2otGJ0B0e7sqIOsT3mPR0KfZOz/aOvzlU6jzeWEVUKJzg+lys2lCm/GHewTVSBpOSc3i1LX6HJb1Fb2sB59Y0ASsCZ3U3e2UstJ69Y3C5tRaFN5JbYz0bwi6SSnuDN1XzyyJGSoRO1h+6z0bkbTVES4jUi3AUUBshlDHAB6TT9pS53W89dlXpbrYMBEAcV6EUtkLPlM9vu+AW56ZYDHsq4q4ka75NmdOdHNJLZuORDaqYfFRIVgPbF/PpfBKSmROTg+KLjYbMv/6+PaTFkhwUTiFxJZtZSBtDd4dbKaHciPZa87ZIAgIem7zbryXq9vxcv6qwTIznCyA8TJMBLKF7Go5jFj8Cno77
 XMIMak7+
 h70U0AK+e/Z43H58lnFMFpm3VgOS2uEdLax/8pEsn/gQdnHL4e5dQGSi7l1EhVMXwRe06W+NgY6OoH/bnWnV9Kyp5B6TeFjY2fKBfFZP6sF6qlXM2+e9a0eqnMohICMgMT41k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 21:54:30 -0400 Gregory Price <gourry@gourry.net> wrote:
> On Tue, Mar 24, 2026 at 02:35:45PM +0900, Rakie Kim wrote:
> > On Fri, 20 Mar 2026 16:56:05 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> > 
> > Init->Target | node0 | node1 | node2 | node3
> > node0        | 0x38B | 0x89F | 0x9C4 | 0x3AFC
> > node1        | 0x89F | 0x38B | 0x3AFC| 0x4268
> > 
> > I used the identical type of DRAM and CXL memory for both sockets.
> > However, looking at the table, the local CXL access latency from
> > node0->node2 (0x9C4) and node1->node3 (0x4268) shows a massive,
> > unjustified difference. This asymmetry proves that the table is
> > currently unreliable.
> >
> 
> Can you dump your CDAT for each device so you can at least check whether
> the device reports the same latency?
> 
> Would at least tell the interested parties whether this is firmware or
> BIOS issue.
> 
> sudo cat /sys/bus/cxl/devices/endpointN/CDAT | python3 cdat_dump.py
> 
> ~Gregory
> 
< --snip-- >

Hello Gregory,

Thank you for providing the python script. It was incredibly helpful.
I ran it across all the CDAT files found in my sysfs.

For context, my system currently has 16 CXL endpoints attached
(from `endpoint9` to `endpoint24`):
/sys/devices/platform/ACPI0017:00/root0/port.../endpoint.../CDAT

As Dave Jiang recently pointed out in this thread, the Intel BIOS
team confirmed that the HMAT values actually represent "end-to-end"
latency. By comparing these CDAT dump results (which show the
device-level latency) with the HMAT numbers, we should have a much
clearer picture of whether the massive asymmetry originates from the
device firmware itself or from the BIOS calculations.

I have attached the extracted CDAT dump results for the devices below.

Thanks again for your help in isolating this issue!

Rakie Kim


=== CDAT from endpoint16 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint20 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint18 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint17 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint14 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint10 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint23 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint22 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint15 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint11 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint12 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint19 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint13 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint9 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint21 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1

=== CDAT from endpoint24 ===
CDAT Header:
  Length:     208 bytes
  Revision:   1
  Checksum:   0xc3 (OK)
  Sequence:   0

  [0] DSMAS  (Device Scoped Memory Affinity Structure)
    Offset: 16, Length: 24
    DSMAD Handle:  0
    Flags:         0x00 (None)
    DPA Base:      0x0000000000000000
    DPA Length:    0x0000002000000000 (128.00 GiB)

  [1] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 40, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     0 (Access Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [2] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 64, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     1 (Read Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [3] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 88, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     2 (Write Latency)
    Base Unit:     1000
    Entry[0]:      110 -> 110.00 ns (110000 ps)

  [4] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 112, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     3 (Access Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [5] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 136, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     4 (Read Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [6] DSLBIS (Device Scoped Latency and Bandwidth Information Structure)
    Offset: 160, Length: 24
    Handle:        0
    Flags:         0x00
    Data Type:     5 (Write Bandwidth)
    Base Unit:     1000
    Entry[0]:      45 -> 43.95 GB/s (45000 MB/s)

  [7] DSEMTS (Device Scoped EFI Memory Type Structure)
    Offset: 184, Length: 24
    DSMAS Handle:  0
    Memory Type:   0 (EfiConventionalMemory)
    DPA Offset:    0x0000000000000000
    Range Length:  0x0000002000000000 (128.00 GiB)

Summary: 8 entries
  DSMAS  (Device Scoped Memory Affinity Structure): 1
  DSLBIS (Device Scoped Latency and Bandwidth Information Structure): 6
  DSEMTS (Device Scoped EFI Memory Type Structure): 1


